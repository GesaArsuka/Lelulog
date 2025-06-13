import 'product.dart';

class TransactionItem {
  final int id;
  final int quantity;
  final int subtotal;
  final Product product;

  TransactionItem({
    required this.id,
    required this.quantity,
    required this.subtotal,
    required this.product,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      subtotal: json['subtotal'] as int,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );
  }
}
