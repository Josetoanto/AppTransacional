import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';

class DeleteHilo {
  DeleteHilo(this._repository);

  final HilosRepository _repository;

  Future<void> call({required String hiloId}) {
    return _repository.deleteHilo(hiloId: hiloId);
  }
}
