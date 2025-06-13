import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api.dart';
import '../services/transaction_api.dart';
import '../widgets/quantity_dialog.dart';
import '../screens/checkout_screen.dart';

class NewSalesPage extends StatefulWidget {
  final String token;
  final int userId;

  const NewSalesPage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  _NewSalesPageState createState() => _NewSalesPageState();
}

class _NewSalesPageState extends State<NewSalesPage> {
  List<Product> products = [];
  Map<int, int> selectedQuantities = {}; // productId -> quantity
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  int get calculatedTotal {
    int total = 0;
    selectedQuantities.forEach((productId, qty) {
      final product = products.firstWhere((p) => p.id == productId, orElse: () => Product(id: 0, name: "", price: 0, stock: 0));
      total += product.price * qty;
    });
    return total;
  }


  Future<void> loadProducts() async {
    try {
      final fetched = await ProductApi.fetchProducts(widget.token);
      setState(() {
        products = fetched;
        loading = false;
      });
    } catch (e) {
      print("Error loading products: $e");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products")),
      );
    }
  }


  int get totalSelected =>
      selectedQuantities.values.fold(0, (sum, qty) => sum + qty);

  void _selectQuantity(Product product) async {
    int? quantity = await showDialog(
      context: context,
      builder: (_) => QuantityDialog(
        productName: product.name,
        stock: product.stock,
        currentQuantity: selectedQuantities[product.id] ?? 0,
        price: product.price,
      ),
    );

    if (quantity != null) {
      setState(() {
        selectedQuantities[product.id] = quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Sale")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Stock: ${p.stock}"),
                              if (p.topNotes != null)
                                Text("Top Notes: ${p.topNotes}"),
                              if (p.heartNotes != null)
                                Text("Heart Notes: ${p.heartNotes}"),
                              if (p.baseNotes != null)
                                Text("Base Notes: ${p.baseNotes}"),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _selectQuantity(p),
                            child: Text("Add to cart"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                minimum: EdgeInsets.only(bottom: 8), // ⬆ shift it slightly above system bar
                child: Container(
                  color: Colors.yellow[700],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$totalSelected Selected",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final txId = await TransactionApi.createTemporaryTransaction(
                            cartItems: selectedQuantities,
                            token: widget.token,
                          );

                          if (txId == null) { /* show failure */ return; }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(
                                transactionId: txId,
                                cartItems: selectedQuantities,
                                totalPrice: calculatedTotal,
                                token: widget.token,
                              ),
                            ),
                          );
                        },
                      child: Text("Done"),
                      ),
                    ],
                  ),
                ), 
              ),
            ]
          ),
        );
      }
    }