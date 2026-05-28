import 'package:apptransaccional/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SectionPlaceholder(
        title: 'Register',
        message: 'Pantalla placeholder para el registro de usuario.',
      ),
    );
  }
}
