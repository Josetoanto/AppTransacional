import 'package:apptransaccional/features/auth/presentation/provider/auth_provider.dart';
import 'package:apptransaccional/features/auth/presentation/ui_state/auth_ui_state.dart';
import 'package:apptransaccional/shared/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// StatefulWidget because it owns local form state/controllers and reacts to one-time side effects.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _didResetProvider = false;
  AuthStatus? _lastStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didResetProvider) {
      return;
    }

    _didResetProvider = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<AuthProvider>().reset();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await context.read<AuthProvider>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _handleAuthEffects(AuthUiState uiState) {
    if (!mounted || _lastStatus == uiState.status) {
      return;
    }

    _lastStatus = uiState.status;
    if (uiState.status == AuthStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso.')),
        );
        Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
      });
    }

    if (uiState.status == AuthStatus.error && uiState.message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(uiState.message!)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final uiState = authProvider.state;
          _handleAuthEffects(uiState);

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
                      onPressed: _submitRegister,
                      child: const Text('Registrar usuario'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        AppConstants.routeLogin,
                      );
                    },
                    child: const Text('Ya tengo cuenta'),
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
