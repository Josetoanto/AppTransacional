import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/create_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/delete_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/get_hilos.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/update_hilo.dart';
import 'package:apptransaccional/features/hilos/presentation/ui_state/hilos_ui_state.dart';
import 'package:flutter/foundation.dart';

class HilosProvider extends ChangeNotifier {
  HilosProvider({
    required this.getHilos,
    required this.createHilo,
    required this.updateHilo,
    required this.deleteHilo,
    required this.currentUserIdResolver,
  });

  final GetHilos getHilos;
  final CreateHilo createHilo;
  final UpdateHilo updateHilo;
  final DeleteHilo deleteHilo;
  final String? Function() currentUserIdResolver;

  HilosUiState _state = HilosUiState.loading();

  HilosUiState get state => _state;

  Future<void> fetchAll() async {
    _state = HilosUiState.loading();
    notifyListeners();

    try {
      final hilos = await getHilos();
      if (hilos.isEmpty) {
        _state = HilosUiState.empty();
      } else {
        _state = HilosUiState.loaded(hilos);
      }
      notifyListeners();
    } on AppException catch (exception) {
      _state = HilosUiState.error(message: exception.message, hilos: _state.hilos);
      notifyListeners();
    } catch (_) {
      _state = HilosUiState.error(
        message: 'Unexpected error while loading hilos.',
        hilos: _state.hilos,
      );
      notifyListeners();
    }
  }

  Future<void> create({required String contenidoTexto}) async {
    final currentUserId = currentUserIdResolver();
    if (currentUserId == null || currentUserId.isEmpty) {
      _state = HilosUiState.error(
        message: 'User must be authenticated to create hilos.',
        hilos: _state.hilos,
      );
      notifyListeners();
      return;
    }

    try {
      final created = await createHilo(
        usuarioId: currentUserId,
        contenidoTexto: contenidoTexto,
        fechaCreacion: DateTime.now(),
      );

      final updatedList = <Hilo>[created, ..._state.hilos];
      _state = HilosUiState.loaded(updatedList);
      notifyListeners();
    } on AppException catch (exception) {
      _state = HilosUiState.error(message: exception.message, hilos: _state.hilos);
      notifyListeners();
    } catch (_) {
      _state = HilosUiState.error(
        message: 'Unexpected error while creating hilo.',
        hilos: _state.hilos,
      );
      notifyListeners();
    }
  }

  Future<void> update({required Hilo hilo, required String nuevoContenido}) async {
    if (!_validateOwnership(hilo)) {
      return;
    }

    try {
      final updated = await updateHilo(
        hilo: hilo.copyWith(contenidoTexto: nuevoContenido),
      );

      final updatedList = _state.hilos
          .map((item) => item.id == updated.id ? updated : item)
          .toList();

        _state = updatedList.isEmpty
          ? HilosUiState.empty()
          : HilosUiState.loaded(updatedList);
      notifyListeners();
    } on AppException catch (exception) {
      _state = HilosUiState.error(message: exception.message, hilos: _state.hilos);
      notifyListeners();
    } catch (_) {
      _state = HilosUiState.error(
        message: 'Unexpected error while updating hilo.',
        hilos: _state.hilos,
      );
      notifyListeners();
    }
  }

  Future<void> delete({required Hilo hilo}) async {
    if (!_validateOwnership(hilo)) {
      return;
    }

    try {
      await deleteHilo(hiloId: hilo.id);

      final updatedList = _state.hilos.where((item) => item.id != hilo.id).toList();
        _state = updatedList.isEmpty
          ? HilosUiState.empty()
          : HilosUiState.loaded(updatedList);
      notifyListeners();
    } on AppException catch (exception) {
      _state = HilosUiState.error(message: exception.message, hilos: _state.hilos);
      notifyListeners();
    } catch (_) {
      _state = HilosUiState.error(
        message: 'Unexpected error while deleting hilo.',
        hilos: _state.hilos,
      );
      notifyListeners();
    }
  }

  bool _validateOwnership(Hilo hilo) {
    final currentUserId = currentUserIdResolver();
    if (currentUserId == null || currentUserId.isEmpty) {
      _state = HilosUiState.error(
        message: 'User must be authenticated to modify hilos.',
        hilos: _state.hilos,
      );
      notifyListeners();
      return false;
    }

    if (hilo.usuarioId != currentUserId) {
      _state = HilosUiState.error(
        message: 'Ownership validation failed for this hilo.',
        hilos: _state.hilos,
      );
      notifyListeners();
      return false;
    }

    return true;
  }
}
