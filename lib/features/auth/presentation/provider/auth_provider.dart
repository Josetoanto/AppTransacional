import 'package:apptransaccional/core/errors/exceptions.dart';
import 'package:apptransaccional/features/auth/domain/usecases/login_user.dart';
import 'package:apptransaccional/features/auth/domain/usecases/register_user.dart';
import 'package:apptransaccional/features/auth/presentation/ui_state/auth_ui_state.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._loginUser, this._registerUser);

  final LoginUser _loginUser;
  final RegisterUser _registerUser;

  AuthUiState _state = AuthUiState.idle();

  AuthUiState get state => _state;

  Future<void> login({required String email, required String password}) async {
    _state = AuthUiState.loading();
    notifyListeners();

    try {
      final user = await _loginUser(email: email, password: password);
      debugPrint('Login token: ${user.token}');
      _state = AuthUiState.success(user);
      notifyListeners();
    } on AppException catch (exception) {
      _state = AuthUiState.error(exception.message);
      notifyListeners();
    } catch (_) {
      _state = AuthUiState.error('Unexpected error during login.');
      notifyListeners();
    }
  }

  Future<void> register({required String email, required String password}) async {
    _state = AuthUiState.loading();
    notifyListeners();

    try {
      final user = await _registerUser(email: email, password: password);
      _state = AuthUiState.success(user);
      notifyListeners();
    } on AppException catch (exception) {
      _state = AuthUiState.error(exception.message);
      notifyListeners();
    } catch (_) {
      _state = AuthUiState.error('Unexpected error during register.');
      notifyListeners();
    }
  }

  void reset() {
    _state = AuthUiState.idle();
    notifyListeners();
  }
}
