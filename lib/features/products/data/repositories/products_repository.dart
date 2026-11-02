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
}
