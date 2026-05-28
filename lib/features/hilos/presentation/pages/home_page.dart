import 'package:apptransaccional/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SectionPlaceholder(
        title: 'Home',
        message: 'Pantalla placeholder principal de la feature hilos.',
      ),
    );
  }
}
