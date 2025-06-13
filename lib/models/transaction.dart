import 'package:intl/intl.dart';
import 'transaction_item.dart';

class Transaction {
  final int id;
  final int totalPrice;
  final DateTime createdAt;
  final List<TransactionItem> items;

  Transaction({
    required this.id,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      totalPrice: json['total_price'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['transaction_items'] as List)
          .map((i) => TransactionItem.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  String get formattedDate {
    // dd.MM.yyyy
    return DateFormat('dd.MM.yyyy').format(createdAt);
  }
}
