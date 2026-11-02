import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../auth/data/auth_repository.dart';
import '../../../products/data/models/product.dart';

class WishlistRepository {
  WishlistRepository(this._authRepository);
  static const _url = 'https://ecommerce.routemisr.com/api/v1/wishlist';
  final AuthRepository _authRepository;
  Future<List<Product>?> getCachedWishlist() async {
    final cached = Hive.box<String>(
      'wishlist_cache',
    ).get(await _authRepository.getToken());
    if (cached == null) return null;
    return _products(jsonDecode(cached));
  }

  Future<List<Product>> getWishlist() async {
    final response = await http.get(Uri.parse(_url), headers: await _headers());
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    _success(response, body);
    final products = _products(body['data']);
    await Hive.box<String>(
      'wishlist_cache',
    ).put(await _authRepository.getToken(), jsonEncode(body['data']));
    return products;
  }

  Future<void> add(String id) async => _success(
    await http.post(
      Uri.parse(_url),
      headers: await _headers(json: true),
      body: jsonEncode({'productId': id}),
    ),
  );
  Future<void> remove(String id) async => _success(
    await http.delete(Uri.parse('$_url/$id'), headers: await _headers()),
  );
  Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await _authRepository.getToken();
    if (token.isEmpty) throw Exception('Please sign in first');
    return {if (json) 'Content-Type': 'application/json', 'token': token};
  }

  List<Product> _products(dynamic data) => data is List
      ? data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList()
      : const [];
  void _success(http.Response response, [Map<String, dynamic>? body]) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    final decoded = body ?? jsonDecode(response.body) as Map<String, dynamic>;
    throw Exception(
      decoded['message'] as String? ?? 'Could not update favourites',
    );
  }
}
