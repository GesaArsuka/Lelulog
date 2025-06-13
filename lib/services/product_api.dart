import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/product.dart';

class ProductApi {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// Fetch all products. If [token] is provided, add Authorization header.
  static Future<List<Product>> fetchProducts([String? token]) async {
    final uri = Uri.parse('$baseUrl/products');
    final headers = <String, String>{
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((p) => Product.fromJson(p as Map<String, dynamic>)).toList();
    } else {
      print('Product API failed: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  /// Create a new product on the server, optionally uploading an image.
  static Future<Product> createProduct({
    required String token,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/products');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(data.map((k, v) => MapEntry(k, v.toString())));

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', imageFile.path.endsWith('.png') ? 'png' : 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      print('Create product failed: ${response.statusCode} ${response.body}');
      throw Exception('Failed to create product');
    }
  }

  /// Update an existing product, optionally uploading a new image.
  static Future<Product> updateProduct({
    required int id,
    required String token,
    required Map<String, dynamic> changes,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      // Laravel expects POST _method=PUT for multipart updates
      ..fields['_method'] = 'PUT'
      ..fields.addAll(changes.map((k, v) => MapEntry(k, v.toString())));

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', imageFile.path.endsWith('.png') ? 'png' : 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      print('Update product failed: ${response.statusCode} ${response.body}');
      throw Exception('Failed to update product');
    }
  }
}
