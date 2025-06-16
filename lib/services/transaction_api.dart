import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionApi {
  static const String baseUrl = 'https://0b05-2404-c0-2c10-00-32f0-6f18.ngrok-free.app/api'; 

  //create temp session for temp cart
  static Future<int?> createTemporaryTransaction({
    required Map<int, int> cartItems, // productId -> quantity
    required String token,
  }) async {
    // Build the items payload
    final itemsPayload = cartItems.entries
        .map((e) => {'product_id': e.key, 'quantity': e.value})
        .toList();

    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'items': itemsPayload}),
    );

    print('➤ createTemporaryTransaction status: ${response.statusCode}');
    print('➤ body: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['id'] as int;
    }
    return null;
  }


  //finalize transaction
  static Future<bool> finalizeTransaction({
    required int transactionId,
    required String token,
    required http.MultipartFile paymentProof,
  }) async {
    var uri = Uri.parse('$baseUrl/transactions/$transactionId/finalize');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(paymentProof);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200;
  }

  /// Fetch all transactions (with items & products).
  static Future<List<Transaction>> fetchTransactions(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      final List jsonList = jsonDecode(res.body);
      return jsonList
          .map((j) => Transaction.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load transactions');
  }
}