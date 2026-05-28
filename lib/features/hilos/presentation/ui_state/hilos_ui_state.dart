import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';

enum HilosStatus { loading, loaded, empty, error }

class HilosUiState {
  const HilosUiState._({
    required this.status,
    required this.hilos,
    this.message,
  });

  const HilosUiState.loading() : this._(status: HilosStatus.loading, hilos: const []);

  const HilosUiState.loaded(List<Hilo> hilos)
    : this._(status: HilosStatus.loaded, hilos: hilos);

  const HilosUiState.empty()
    : this._(status: HilosStatus.empty, hilos: const []);

  const HilosUiState.error({required String message, required List<Hilo> hilos})
    : this._(status: HilosStatus.error, hilos: hilos, message: message);

  final HilosStatus status;
  final List<Hilo> hilos;
  final String? message;
}
