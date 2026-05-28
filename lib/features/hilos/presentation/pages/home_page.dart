import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/presentation/pages/hilo_editor_page.dart';
import 'package:apptransaccional/features/hilos/presentation/provider/hilos_provider.dart';
import 'package:apptransaccional/features/hilos/presentation/ui_state/hilos_ui_state.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HilosProvider _hilosProvider;

  @override
  void initState() {
    super.initState();
    _hilosProvider = AppInjector.hilosProvider;
    _hilosProvider.fetchAll();
  }

  Future<void> _openCreateEditor() async {
    final contenido = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const HiloEditorPage()),
    );

    if (!mounted || contenido == null) {
      return;
    }

    await _hilosProvider.create(contenidoTexto: contenido);
  }

  Future<void> _openEditEditor(Hilo hilo) async {
    final contenido = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => HiloEditorPage(initialContenido: hilo.contenidoTexto),
      ),
    );

    if (!mounted || contenido == null) {
      return;
    }

    await _hilosProvider.update(hilo: hilo, nuevoContenido: contenido);
  }

  Future<void> _confirmDelete(Hilo hilo) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar hilo'),
          content: const Text('Esta accion no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (delete != true) {
      return;
    }

    await _hilosProvider.delete(hilo: hilo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed de hilos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateEditor,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo hilo'),
      ),
      body: AnimatedBuilder(
        animation: _hilosProvider,
        builder: (context, _) {
          final uiState = _hilosProvider.state;
          switch (uiState.status) {
            case HilosStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case HilosStatus.empty:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('No hay hilos aun.'),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _openCreateEditor,
                        child: const Text('Crear el primer hilo'),
                      ),
                    ],
                  ),
                ),
              );
            case HilosStatus.error:
            case HilosStatus.loaded:
              return Column(
                children: [
                  if (uiState.status == HilosStatus.error && uiState.message != null)
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.errorContainer,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        uiState.message!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  Expanded(child: _buildHilosList(uiState.hilos)),
                ],
              );
          }
        },
      ),
    );
  }

  Widget _buildHilosList(List<Hilo> hilos) {
    final currentUserId = AppInjector.authProvider.state.user?.id;

    return RefreshIndicator(
      onRefresh: _hilosProvider.fetchAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: hilos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final hilo = hilos[index];
          final isOwner = hilo.usuarioId == currentUserId;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hilo.contenidoTexto,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Autor: ${hilo.usuarioId} | ${hilo.fechaCreacion.toLocal()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (isOwner)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _openEditEditor(hilo),
                          child: const Text('Editar'),
                        ),
                        TextButton(
                          onPressed: () => _confirmDelete(hilo),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
