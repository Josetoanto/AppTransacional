import 'package:flutter/material.dart';

// StatelessWidget because it only receives an external callback and keeps no internal state.
class CreateHiloButton extends StatelessWidget {
  const CreateHiloButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text('Nuevo hilo'),
    );
  }
}
