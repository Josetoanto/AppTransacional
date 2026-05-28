import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 20),
    this.retryCount = 1,
    Map<String, String>? defaultHeaders,
    this.tokenSecret,
  })  : _client = client ?? http.Client(),
        _defaultHeaders = defaultHeaders ?? const {'Content-Type': 'application/json'};

  factory HttpClient.fromConfig({
    required String baseUrl,
    String? tokenSecret,
    Duration timeout = const Duration(seconds: 20),
    int retryCount = 1,
    Map<String, String>? defaultHeaders,
  }) {
    return HttpClient(
      baseUrl: baseUrl,
      tokenSecret: tokenSecret,
      timeout: timeout,
      retryCount: retryCount,
      defaultHeaders: defaultHeaders,
    );
  }

  HttpClient.withTimeout(
    Duration timeout, {
    required String baseUrl,
    String? tokenSecret,
    int retryCount = 1,
    Map<String, String>? defaultHeaders,
    http.Client? client,
  }) : this(
          baseUrl: baseUrl,
          tokenSecret: tokenSecret,
          timeout: timeout,
          retryCount: retryCount,
          defaultHeaders: defaultHeaders,
          client: client,
        );

  final String baseUrl;
  final String? tokenSecret;
  final Duration timeout;
  final int retryCount;
  final http.Client _client;
  final Map<String, String> _defaultHeaders;

  Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    return _sendWithRetry(() {
      return _client.get(_buildUri(path), headers: _mergeHeaders(headers));
    });
  }

  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    return _sendWithRetry(() {
      return _client.post(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      );
    });
  }

  Future<dynamic> put(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    return _sendWithRetry(() {
      return _client.put(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      );
    });
  }

  Future<dynamic> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    return _sendWithRetry(() {
      return _client.delete(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      );
    });
  }

  Uri _buildUri(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.parse(path);
    }

    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath');
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    final merged = <String, String>{..._defaultHeaders, ...?headers};
    if (tokenSecret != null && tokenSecret!.isNotEmpty && !merged.containsKey('Authorization')) {
      merged['Authorization'] = 'Bearer $tokenSecret';
    }

    return merged;
  }

  Future<dynamic> _sendWithRetry(Future<http.Response> Function() request) async {
    var attempts = 0;

    while (true) {
      attempts++;
      try {
        final response = await request().timeout(timeout);
        return _handleResponse(response);
      } on TimeoutException {
        if (attempts > retryCount) {
          throw NetworkException('Request timeout after $attempts attempt(s).');
        }
      } on SocketException {
        if (attempts > retryCount) {
          throw NetworkException('No internet connection available.');
        }
      } on ServerException {
        if (attempts > retryCount) {
          rethrow;
        }
      }
    }
  }

  dynamic _handleResponse(http.Response response) {
    final decodedBody = _decodeJson(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    }

    final message = _extractErrorMessage(decodedBody, response.statusCode);

    switch (response.statusCode) {
      case 400:
        throw ValidationException(message);
      case 401:
        throw UnauthorizedException(message);
      case 404:
        throw NotFoundException(message);
      case 500:
        throw ServerException(message);
      default:
        throw NetworkException(message);
    }
  }

  dynamic _decodeJson(String rawBody) {
    if (rawBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      return jsonDecode(rawBody);
    } on FormatException {
      throw ServerException('Invalid JSON response from server.');
    }
  }

  String _extractErrorMessage(dynamic decodedBody, int statusCode) {
    if (decodedBody is Map<String, dynamic>) {
      return decodedBody['message']?.toString() ??
          decodedBody['error']?.toString() ??
          'Request failed with status code $statusCode.';
    }

    return 'Request failed with status code $statusCode.';
  }
}
