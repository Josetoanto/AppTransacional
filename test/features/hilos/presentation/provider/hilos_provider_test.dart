import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/create_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/delete_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/get_hilos.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/update_hilo.dart';
import 'package:apptransaccional/features/hilos/presentation/provider/hilos_provider.dart';
import 'package:apptransaccional/features/hilos/presentation/ui_state/hilos_ui_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHilosRepository implements HilosRepository {
  _FakeHilosRepository(this._items);

  final List<Hilo> _items;

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
    _items.insert(0, hilo);
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
  group('HilosProvider', () {
    late _FakeHilosRepository repository;
    late HilosProvider provider;

    setUp(() {
      repository = _FakeHilosRepository([
        Hilo(
          id: '1',
          usuarioId: 'owner-1',
          contenidoTexto: 'Texto inicial',
          fechaCreacion: DateTime(2026, 1, 1),
        ),
      ]);

      provider = HilosProvider(
        getHilos: GetHilos(repository),
        createHilo: CreateHilo(repository),
        updateHilo: UpdateHilo(repository),
        deleteHilo: DeleteHilo(repository),
        currentUserIdResolver: () => 'owner-1',
      );
    });

    test('fetchAll loads hilos', () async {
      await provider.fetchAll();

      expect(provider.state.status, HilosStatus.loaded);
      expect(provider.state.hilos, hasLength(1));
    });

    test('create adds new hilo', () async {
      await provider.fetchAll();
      await provider.create(contenidoTexto: 'Nuevo hilo');

      expect(provider.state.status, HilosStatus.loaded);
      expect(provider.state.hilos, hasLength(2));
    });

    test('update fails when ownership validation fails', () async {
      provider = HilosProvider(
        getHilos: GetHilos(repository),
        createHilo: CreateHilo(repository),
        updateHilo: UpdateHilo(repository),
        deleteHilo: DeleteHilo(repository),
        currentUserIdResolver: () => 'other-user',
      );

      await provider.fetchAll();
      await provider.update(
        hilo: provider.state.hilos.first,
        nuevoContenido: 'No permitido',
      );

      expect(provider.state.status, HilosStatus.error);
      expect(provider.state.message, contains('Ownership validation failed'));
    });

    test('delete removes hilo for owner', () async {
      await provider.fetchAll();
      await provider.delete(hilo: provider.state.hilos.first);

      expect(provider.state.status, HilosStatus.empty);
      expect(provider.state.hilos, isEmpty);
    });
  });
}
