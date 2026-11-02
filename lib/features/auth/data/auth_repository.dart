import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _baseUrl = 'https://ecommerce.routemisr.com/api/v1/auth';
  static const _tokenKey = 'auth_token';

  Future<void> signIn({required String email, required String password}) {
    return _authenticate('signin', {'email': email, 'password': password});
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return _authenticate('signup', {
      'name': name,
      'email': email,
      'password': password,
      'rePassword': password,
      'phone': phone,
    });
  }

  Future<void> _authenticate(String path, Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errors = data['errors'];
      final detailedMessage = errors is Map<String, dynamic>
          ? errors['msg'] as String?
          : null;
      throw AuthException(
        detailedMessage ??
            data['message'] as String? ??
            'Authentication failed',
      );
    }
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw AuthException('No authentication token returned');
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  Future<bool> hasActiveSession() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getString(_tokenKey) ?? '').isNotEmpty;
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}
