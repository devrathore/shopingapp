

import 'dart:async';
import 'dart:convert';
import 'package:ellemora/model/product.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Stream<List<String>> fetchCategories() async* {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      yield List<String>.from(data);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Stream<List<Product>> fetchProducts({String? category}) async* {
    String url = '$baseUrl/products';
    if (category != null) {
      url += '/category/$category';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      yield List<Product>.from(data.map((json) => Product.fromJson(json)));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
