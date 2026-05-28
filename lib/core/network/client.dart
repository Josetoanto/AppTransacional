import 'dart:convert';
import 'dart:io';

import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class NetworkClient {
  NetworkClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  http.Client get httpClient => _httpClient;

  Future<Map<String, dynamic>> postJson({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse(url),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decodedBody;
      }

      throw NetworkException(
        decodedBody['error']?.toString() ??
            'Request failed with status code ${response.statusCode}.',
      );
    } on SocketException {
      throw NetworkException('No internet connection available.');
    } on FormatException {
      throw NetworkException('Invalid response format from server.');
    }
  }
}
