import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:apptransaccional/core/network/http_client.dart';
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
  HilosRemoteDataSourceImpl(
    this._httpClient, {
    this.hilosPath = '/hilos',
  });

  final HttpClient _httpClient;
  final String hilosPath;

  @override
  Future<List<HiloModel>> getAll() async {
    final body = await _httpClient.get(hilosPath);

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
    final body = await _httpClient.post(
      hilosPath,
      body: <String, dynamic>{
        'userId': usuarioId,
        'body': contenidoTexto,
        'createdAt': fechaCreacion.toIso8601String(),
      },
    );

    if (body is! Map<String, dynamic>) {
      throw NetworkException('Invalid response format for created hilo.');
    }

    return HiloModel.fromJson(body);
  }

  @override
  Future<HiloModel> update({required HiloModel hilo}) async {
    final body = await _httpClient.put(
      '$hilosPath/${hilo.id}',
      body: hilo.toJson(),
    );

    if (body is! Map<String, dynamic>) {
      throw NetworkException('Invalid response format for updated hilo.');
    }

    return HiloModel.fromJson(body);
  }

  @override
  Future<void> delete({required String hiloId}) async {
    await _httpClient.delete('$hilosPath/$hiloId');
  }
}
