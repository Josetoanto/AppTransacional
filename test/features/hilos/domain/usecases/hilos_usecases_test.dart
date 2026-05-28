import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/create_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/delete_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/get_hilos.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/update_hilo.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHilosRepository implements HilosRepository {
  final List<Hilo> _items = [];

  @override
  Future<Hilo> createHilo({
    required String usuarioId,
    required String contenidoTexto,
    required DateTime fechaCreacion,
  }) async {
    final hilo = Hilo(
      id: (_items.length + 1).toString(),
      usuarioId: usuarioId,
      contenidoTexto: contenidoTexto,
      fechaCreacion: fechaCreacion,
    );
    _items.add(hilo);
    return hilo;
  }

  @override
  Future<void> deleteHilo({required String hiloId}) async {
    _items.removeWhere((item) => item.id == hiloId);
  }

  @override
  Future<List<Hilo>> getHilos() async {
    return List<Hilo>.from(_items);
  }

  @override
  Future<Hilo> updateHilo({required Hilo hilo}) async {
    final index = _items.indexWhere((item) => item.id == hilo.id);
    _items[index] = hilo;
    return hilo;
  }
}

void main() {
  test('Hilos use cases work together', () async {
    final repo = _FakeHilosRepository();
    final create = CreateHilo(repo);
    final getAll = GetHilos(repo);
    final update = UpdateHilo(repo);
    final delete = DeleteHilo(repo);

    final created = await create(
      usuarioId: 'u-1',
      contenidoTexto: 'Primer hilo',
      fechaCreacion: DateTime(2026, 1, 1),
    );

    expect(created.id, '1');

    final updated = await update(
      hilo: created.copyWith(contenidoTexto: 'Hilo editado'),
    );
    expect(updated.contenidoTexto, 'Hilo editado');

    final all = await getAll();
    expect(all, hasLength(1));

    await delete(hiloId: created.id);
    final empty = await getAll();
    expect(empty, isEmpty);
  });
}
