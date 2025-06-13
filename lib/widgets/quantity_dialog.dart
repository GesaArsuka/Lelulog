import 'package:flutter/material.dart';

class QuantityDialog extends StatefulWidget {
  final String productName;
  final int stock;
  final int currentQuantity;
  final int price;

  const QuantityDialog({
    required this.productName,
    required this.stock,
    required this.currentQuantity,
    required this.price,
  });

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = widget.currentQuantity > 0 ? widget.currentQuantity : 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Quantity\n${widget.productName}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: quantity > 1
                    ? () => setState(() => quantity--)
                    : null,
                icon: Icon(Icons.remove_circle_outline),
              ),
              Text('$quantity', style: TextStyle(fontSize: 24)),
              IconButton(
                onPressed: quantity < widget.stock
                    ? () => setState(() => quantity++)
                    : null,
                icon: Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "${quantity}x = Rp ${widget.price * quantity}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(widget.currentQuantity),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(quantity),
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
