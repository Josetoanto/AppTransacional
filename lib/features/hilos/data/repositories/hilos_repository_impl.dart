import 'package:apptransaccional/features/hilos/data/datasources/hilos_remote_data_source.dart';
import 'package:apptransaccional/features/hilos/data/models/hilo_model.dart';
import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';

class HilosRepositoryImpl implements HilosRepository {
  HilosRepositoryImpl({required this.remoteDataSource});

  final HilosRemoteDataSource remoteDataSource;

  @override
  Future<List<Hilo>> getHilos() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Hilo> createHilo({
    required String usuarioId,
    required String contenidoTexto,
    required DateTime fechaCreacion,
  }) async {
    final model = await remoteDataSource.create(
      usuarioId: usuarioId,
      contenidoTexto: contenidoTexto,
      fechaCreacion: fechaCreacion,
    );

    return model.toEntity();
  }

  @override
  Future<Hilo> updateHilo({required Hilo hilo}) async {
    final updatedModel = await remoteDataSource.update(
      hilo: HiloModel.fromEntity(hilo),
    );

    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteHilo({required String hiloId}) {
    return remoteDataSource.delete(hiloId: hiloId);
  }
}
