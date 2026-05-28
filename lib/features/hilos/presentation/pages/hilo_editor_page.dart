import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';
import 'package:flutter/material.dart';

// StatefulWidget because it keeps local form state and text controller during editing.
class HiloEditorPage extends StatefulWidget {
  const HiloEditorPage({
    super.key,
    this.hilo,
  });

  final Hilo? hilo;

  @override
  State<HiloEditorPage> createState() => _HiloEditorPageState();
}

class _HiloEditorPageState extends State<HiloEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contenidoController;

  @override
  void initState() {
    super.initState();
    _contenidoController = TextEditingController(
      text: widget.hilo?.contenidoTexto ?? '',
    );
  }

  @override
  void dispose() {
    _contenidoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(_contenidoController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.hilo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar hilo' : 'Nuevo hilo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contenidoController,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El contenido es requerido.';
                  }

                  if (value.trim().length < 3) {
                    return 'Ingresa al menos 3 caracteres.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(isEditing ? 'Guardar cambios' : 'Crear hilo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
