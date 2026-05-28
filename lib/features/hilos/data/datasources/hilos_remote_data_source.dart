import 'dart:convert';

import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:apptransaccional/core/network/client.dart';
import 'package:apptransaccional/features/hilos/data/models/hilo_model.dart';

abstract class HilosRemoteDataSource {
  Future<List<HiloModel>> getAll();

  Future<HiloModel> create({
    required String usuarioId,
    required String contenidoTexto,
    required DateTime fechaCreacion,
  });

  Future<HiloModel> update({required HiloModel hilo});

  Future<void> delete({required String hiloId});
}

class HilosRemoteDataSourceImpl implements HilosRemoteDataSource {
  HilosRemoteDataSourceImpl(this._networkClient);

  final NetworkClient _networkClient;

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Future<List<HiloModel>> getAll() async {
    final response = await _networkClient.httpClient.get(Uri.parse(_baseUrl));
    final body = _decodeBody(response.body);

    _throwIfError(statusCode: response.statusCode, body: body);

    if (response.statusCode != 200) {
      throw NetworkException('Unexpected status while loading hilos.');
    }

    if (body is! List) {
      throw NetworkException('Invalid response format for hilos list.');
    }

    return body
        .map((item) => HiloModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<HiloModel> create({
    required String usuarioId,
    required String contenidoTexto,
    required DateTime fechaCreacion,
  }) async {
    final response = await _networkClient.httpClient.post(
      Uri.parse(_baseUrl),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'userId': usuarioId,
        'body': contenidoTexto,
        'createdAt': fechaCreacion.toIso8601String(),
      }),
    );

    final body = _decodeBody(response.body);
    _throwIfError(statusCode: response.statusCode, body: body);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw NetworkException('Unexpected status while creating hilo.');
    }

    if (body is! Map<String, dynamic>) {
      throw NetworkException('Invalid response format for created hilo.');
    }

    return HiloModel.fromJson(body);
  }

  @override
  Future<HiloModel> update({required HiloModel hilo}) async {
    final response = await _networkClient.httpClient.put(
      Uri.parse('$_baseUrl/${hilo.id}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(hilo.toJson()),
    );

    final body = _decodeBody(response.body);
    _throwIfError(statusCode: response.statusCode, body: body);

    if (response.statusCode != 200) {
      throw NetworkException('Unexpected status while updating hilo.');
    }

    if (body is! Map<String, dynamic>) {
      throw NetworkException('Invalid response format for updated hilo.');
    }

    return HiloModel.fromJson(body);
  }

  @override
  Future<void> delete({required String hiloId}) async {
    final response = await _networkClient.httpClient.delete(
      Uri.parse('$_baseUrl/$hiloId'),
    );

    final body = _decodeBody(response.body);
    _throwIfError(statusCode: response.statusCode, body: body);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw NetworkException('Unexpected status while deleting hilo.');
    }
  }

  dynamic _decodeBody(String rawBody) {
    if (rawBody.isEmpty) {
      return <String, dynamic>{};
    }

    return jsonDecode(rawBody);
  }

  void _throwIfError({required int statusCode, required dynamic body}) {
    if (statusCode >= 200 && statusCode < 300) {
      return;
    }

    final message = _extractErrorMessage(body);

    switch (statusCode) {
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

  String _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body['error']?.toString() ?? body['message']?.toString() ?? 'Unknown API error.';
    }

    return 'Unknown API error.';
  }
}
