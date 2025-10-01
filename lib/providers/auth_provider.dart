import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuth = false;
  bool get isAuth => _isAuth;

  static const _demoUser = 'admin@mail';
  static const _demoPass = '123456';

  /// Simula un login.
  /// - Retorna true si el login fue exitoso. False si no.
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simula IO
    final ok = email.trim() == _demoUser && password == _demoPass;
    _isAuth = ok;
    notifyListeners();
    return ok;
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
