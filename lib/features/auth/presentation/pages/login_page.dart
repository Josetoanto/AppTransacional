import 'package:apptransaccional/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SectionPlaceholder(
        title: 'Login',
        message: 'Pantalla placeholder para el inicio de sesion.',
      ),
    );
  }
}
