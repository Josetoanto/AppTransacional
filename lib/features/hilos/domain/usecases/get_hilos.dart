import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';

class GetHilos {
  GetHilos(this._repository);

  final HilosRepository _repository;

  Future<List<Hilo>> call() {
    return _repository.getHilos();
  }
}
