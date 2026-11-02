import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _baseUrl = 'https://ecommerce.routemisr.com/api/v1/auth';
  static const _tokenKey = 'auth_token';
  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';
  static const _phoneKey = 'profile_phone';

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
    final user = data['user'] as Map<String, dynamic>?;
    if (user != null) {
      await preferences.setString(
        _nameKey,
        user['name'] as String? ?? 'Route shopper',
      );
      await preferences.setString(_emailKey, user['email'] as String? ?? '');
      await preferences.setString(_phoneKey, user['phone'] as String? ?? '');
    }
  }

  Future<bool> hasActiveSession() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getString(_tokenKey) ?? '').isNotEmpty;
  }

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey) ?? '';
  }

  Future<UserProfile> getProfile() async {
    final preferences = await SharedPreferences.getInstance();
    return UserProfile(
      name: preferences.getString(_nameKey) ?? 'Route shopper',
      email: preferences.getString(_emailKey) ?? '',
      phone: preferences.getString(_phoneKey) ?? '',
    );
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_nameKey);
    await preferences.remove(_emailKey);
    await preferences.remove(_phoneKey);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });
  final String name;
  final String email;
  final String phone;
}
