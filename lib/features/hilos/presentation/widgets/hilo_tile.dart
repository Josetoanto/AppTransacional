import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:flutter/material.dart';

// StatelessWidget because it depends only on external props and keeps no local mutable state.
class HiloTile extends StatelessWidget {
  const HiloTile({
    required this.hilo,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  factory HiloTile.fromType({
    required Hilo hilo,
    required bool isOwner,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required bool compact,
    Key? key,
  }) {
    if (compact) {
      return _CompactHiloTile(
        key: key,
        hilo: hilo,
        isOwner: isOwner,
        onEdit: onEdit,
        onDelete: onDelete,
      );
    }

    return HiloTile(
      key: key,
      hilo: hilo,
      isOwner: isOwner,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  final Hilo hilo;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
                    onPressed: onEdit,
                    child: const Text('Editar'),
                  ),
                  TextButton(
                    onPressed: onDelete,
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CompactHiloTile extends HiloTile {
  const _CompactHiloTile({
    required super.hilo,
    required super.isOwner,
    required super.onEdit,
    required super.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(hilo.contenidoTexto, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('Autor: ${hilo.usuarioId}'),
      trailing: isOwner
          ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else {
                  onDelete();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
            )
          : null,
    );
  }
}
