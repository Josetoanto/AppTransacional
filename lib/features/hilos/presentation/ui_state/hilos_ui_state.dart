import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';

enum HilosStatus { loading, loaded, empty, error }

class HilosUiState {
  const HilosUiState._({
    required this.status,
    required this.hilos,
    this.message,
  });

  factory HilosUiState.loading() =>
      const HilosUiState._(status: HilosStatus.loading, hilos: []);

  factory HilosUiState.loaded(List<Hilo> hilos) =>
      HilosUiState._(status: HilosStatus.loaded, hilos: hilos);

  factory HilosUiState.empty() =>
      const HilosUiState._(status: HilosStatus.empty, hilos: []);

  factory HilosUiState.error({
    required String message,
    required List<Hilo> hilos,
  }) =>
      HilosUiState._(status: HilosStatus.error, hilos: hilos, message: message);

  final HilosStatus status;
  final List<Hilo> hilos;
  final String? message;
}
