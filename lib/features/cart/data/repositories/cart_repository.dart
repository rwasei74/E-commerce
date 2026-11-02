import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../auth/data/auth_repository.dart';
import '../models/cart_models.dart';

class CartRepository {
  CartRepository(this._authRepository);
  static const _baseUrl = 'https://ecommerce.routemisr.com/api/v1/cart';
  static const _cacheBox = 'cart_cache';
  final AuthRepository _authRepository;

  Future<CartData?> getCachedCart() async {
    final cached = Hive.box<String>(_cacheBox).get(await _cacheKey());
    if (cached == null) {
      return null;
    }
    return CartData.fromJson(jsonDecode(cached) as Map<String, dynamic>);
  }

  Future<CartData> getCart() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: await _headers(),
    );
    if (response.statusCode == 404) {
      return _cache(const CartData.empty(), const {});
    }
    return _readCart(response);
  }

  Future<CartData> addProduct(String productId) async => _readCart(
    await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(json: true),
      body: jsonEncode({'productId': productId}),
    ),
  );
  Future<CartData> updateCount(String productId, int count) async => _readCart(
    await http.put(
      Uri.parse('$_baseUrl/$productId'),
      headers: await _headers(json: true),
      body: jsonEncode({'count': count}),
    ),
  );
  Future<CartData> removeProduct(String productId) async => _readCart(
    await http.delete(
      Uri.parse('$_baseUrl/$productId'),
      headers: await _headers(),
    ),
  );

  Future<void> checkout({
    required String cartId,
    required String details,
    required String phone,
    required String city,
  }) async {
    final response = await http.post(
      Uri.parse('https://ecommerce.routemisr.com/api/v1/orders/$cartId'),
      headers: await _headers(json: true),
      body: jsonEncode({
        'shippingAddress': {'details': details, 'phone': phone, 'city': city},
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw Exception(
        (jsonDecode(response.body) as Map<String, dynamic>)['message']
                as String? ??
            'Could not place order',
      );
  }

  Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await _authRepository.getToken();
    if (token.isEmpty) throw Exception('Please sign in first');
    return {if (json) 'Content-Type': 'application/json', 'token': token};
  }

  Future<String> _cacheKey() => _authRepository.getToken();

  CartData _readCart(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(body['message'] as String? ?? 'Could not update cart');
    }
    return _cache(
      CartData.fromJson(body['data'] as Map<String, dynamic>),
      body['data'] as Map<String, dynamic>,
    );
  }

  CartData _cache(CartData cart, Map<String, dynamic> raw) {
    _cacheKey().then(
      (key) => Hive.box<String>(_cacheBox).put(key, jsonEncode(raw)),
    );
    return cart;
  }
}
