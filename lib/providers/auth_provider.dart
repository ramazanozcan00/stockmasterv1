import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// DÜZELTME BURADA: "package:" ile başlayan tam yolları kullanıyoruz
import 'package:stock_master_mobile/models/user_model.dart';
import 'package:stock_master_mobile/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService(); // Artık bunu tanıyacak
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // GİRİŞ YAP
  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.login(username, password);
      if (user != null) {
        _user = user;
        await _saveUserToPhone(user);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ÇIKIŞ YAP
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  // UYGULAMA AÇILINCA OTURUMU GERİ YÜKLE
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> _saveUserToPhone(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }
}
