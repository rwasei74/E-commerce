import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductsRepository {
  static const _baseUrl = 'https://ecommerce.routemisr.com/api/v1';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products?limit=20'));
    if (response.statusCode != 200) throw Exception('Could not load products');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['data'] as List)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final uri = Uri.parse(
      '$_baseUrl/products',
    ).replace(queryParameters: {'category[in]': categoryId, 'limit': '30'});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Could not load category products');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['data'] as List<dynamic>)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> search(String keyword) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/products',
      ).replace(queryParameters: {'keyword': keyword, 'limit': '30'}),
    );
    if (response.statusCode != 200)
      throw Exception('Could not search products');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['data'] as List<dynamic>)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
