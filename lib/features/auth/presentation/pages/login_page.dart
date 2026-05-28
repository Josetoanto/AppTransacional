import 'package:apptransaccional/core/di/app_injector.dart';
import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';
import 'package:apptransaccional/features/auth/presentation/ui_state/auth_ui_state.dart';
import 'package:apptransaccional/shared/constants/app_constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AppInjector.authProvider;
    _authProvider.reset();
    _authProvider.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (!mounted) {
      return;
    }

    if (_authProvider.state.status == AuthStatus.success) {
      Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
    }
  }

  Future<void> _submitLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await _authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: AnimatedBuilder(
        animation: _authProvider,
        builder: (context, _) {
          final uiState = _authProvider.state;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El email es requerido.';
                      }

                      if (!value.contains('@')) {
                        return 'Ingresa un email valido.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El password es requerido.';
                      }

                      if (value.length < 6) {
                        return 'Minimo 6 caracteres.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (uiState.status == AuthStatus.loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: _submitLogin,
                      child: const Text('Iniciar sesion'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppConstants.routeRegister);
                    },
                    child: const Text('Crear cuenta'),
                  ),
                  if (uiState.status == AuthStatus.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        uiState.message ?? 'Error no controlado.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
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
