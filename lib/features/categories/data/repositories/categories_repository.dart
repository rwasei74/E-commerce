import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoriesRepository {
  static const _baseUrl = 'https://ecommerce.routemisr.com/api/v1';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'));
    if (response.statusCode != 200) {
      throw Exception('Could not load categories');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['data'] as List<dynamic>)
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
