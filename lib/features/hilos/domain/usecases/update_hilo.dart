import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';

class UpdateHilo {
  UpdateHilo(this._repository);

  final HilosRepository _repository;

  Future<Hilo> call({required Hilo hilo}) {
    return _repository.updateHilo(hilo: hilo);
  }
}
