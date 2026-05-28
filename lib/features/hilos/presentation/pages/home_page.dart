import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:apptransaccional/features/hilos/presentation/pages/hilo_editor_page.dart';
import 'package:apptransaccional/features/hilos/presentation/provider/hilos_provider.dart';
import 'package:apptransaccional/features/hilos/presentation/ui_state/hilos_ui_state.dart';
import 'package:apptransaccional/features/hilos/presentation/widgets/create_hilo_button.dart';
import 'package:apptransaccional/features/hilos/presentation/widgets/hilo_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// StatefulWidget because it triggers one-time side effects (initial fetch and snackbars) and tracks last observed UI state.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _didRequestInitialData = false;
  HilosStatus? _lastStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRequestInitialData) {
      return;
    }

    _didRequestInitialData = true;
    context.read<HilosProvider>().fetchAll();
  }

  Future<void> _openCreateEditor() async {
    final contenido = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const HiloEditorPage(),
      ),
    );

    if (!mounted || contenido == null) {
      return;
    }

    await context.read<HilosProvider>().create(contenidoTexto: contenido);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hilo creado correctamente.')),
    );
  }

  Future<void> _openEditEditor(Hilo hilo) async {
    final contenido = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => HiloEditorPage(hilo: hilo),
      ),
    );

    if (!mounted || contenido == null) {
      return;
    }

    await context.read<HilosProvider>().update(hilo: hilo, nuevoContenido: contenido);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hilo actualizado correctamente.')),
    );
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

    if (!mounted) {
      return;
    }

    final hilosProvider = context.read<HilosProvider>();
    await hilosProvider.delete(hilo: hilo);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hilo eliminado correctamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed de hilos')),
      floatingActionButton: CreateHiloButton(onPressed: _openCreateEditor),
      body: Consumer<HilosProvider>(
        builder: (context, hilosProvider, _) {
          final uiState = hilosProvider.state;
          _handleStateFeedback(uiState);

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

  void _handleStateFeedback(HilosUiState uiState) {
    if (!mounted || _lastStatus == uiState.status) {
      return;
    }

    _lastStatus = uiState.status;
    if (uiState.status == HilosStatus.error && uiState.message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(uiState.message!)),
        );
      });
    }
  }

  Widget _buildHilosList(List<Hilo> hilos) {
    final currentUserId = context.read<HilosProvider>().currentUserIdResolver();

    return RefreshIndicator(
      onRefresh: context.read<HilosProvider>().fetchAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: hilos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final hilo = hilos[index];
          final isOwner = hilo.usuarioId == currentUserId;

          return HiloTile.fromType(
            hilo: hilo,
            isOwner: isOwner,
            onEdit: () => _openEditEditor(hilo),
            onDelete: () => _confirmDelete(hilo),
            compact: false,
          );
        },
      ),
    );
  }
}
