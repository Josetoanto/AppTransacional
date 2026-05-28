import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';

abstract class HilosRepository {
  Future<List<Hilo>> getHilos();

  Future<Hilo> createHilo({
    required String usuarioId,
    required String contenidoTexto,
    required DateTime fechaCreacion,
  });

  Future<Hilo> updateHilo({required Hilo hilo});

  Future<void> deleteHilo({required String hiloId});
}
