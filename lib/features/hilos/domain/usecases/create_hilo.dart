import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';

class CreateHilo {
  CreateHilo(this._repository);

  final HilosRepository _repository;

  Future<Hilo> call({
    required String usuarioId,
    required String contenidoTexto,
    required DateTime fechaCreacion,
  }) {
    return _repository.createHilo(
      usuarioId: usuarioId,
      contenidoTexto: contenidoTexto,
      fechaCreacion: fechaCreacion,
    );
  }
}
