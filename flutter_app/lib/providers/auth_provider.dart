import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  String? _token;
  bool _isLoading = false;

  bool get isLoggedIn => _token != null;
  bool get isLoading => _isLoading;

  // Called once at app start (from Splash)
  Future<void> loadToken() async {
    _token = await _storage.read(key: _tokenKey);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // TODO: replace with a real Dio call to Member A's API
    await Future.delayed(const Duration(seconds: 1));
    _token = 'fake_token';

    await _storage.write(key: _tokenKey, value: _token);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _token = null;
    notifyListeners();
  }
}