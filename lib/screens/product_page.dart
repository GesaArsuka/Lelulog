import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api.dart';
import 'product_detail.dart';
import 'add_product_page.dart';

class ProductCatalog extends StatefulWidget {
  final String token;

  const ProductCatalog({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  bool _loading = true;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prods = await ProductApi.fetchProducts(widget.token);
      setState(() {
        _products = prods;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products')),
      );
    }
  }

  /// Renders a single product card, tappable to go to detail/edit.
  Widget _buildProductCard(Product p, int index) {
  final hasImage = p.imagePath != null && p.imagePath!.isNotEmpty;
  final imageUrl = hasImage
      ? 'http://10.0.2.2:8000/storage/${p.imagePath!}'
      : null;

  return GestureDetector(
    onTap: () async {
      // Navigate to detail and refresh on return
      final updated = await Navigator.push<Product>(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetail(product: p, token: widget.token),
        ),
      );
      if (updated != null) {
        setState(() => _products[index] = updated);
      }
    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // IMAGE BOX
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasImage
                  ? Icon(Icons.image, color: Colors.white54)
                  : null,
            ),

            SizedBox(width: 16),

            // PRODUCT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Stock: ${p.stock}'),
                  if (p.topNotes != null) Text('Top: ${p.topNotes}'),
                  if (p.heartNotes != null) Text('Heart: ${p.heartNotes}'),
                  if (p.baseNotes != null) Text('Base: ${p.baseNotes}'),
                ],
              ),
            ),

            // CHEVRON
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Catalog'),
        backgroundColor: Colors.yellow[700],
      ),
      body: _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: 
            ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _products.length + 1,
              itemBuilder: (_, i) {
                if (i < _products.length) {
                  return _buildProductCard(_products[i], i);
                } 
                else {
                  return _buildAddNewCard(context);
                }
              },
            ),
          ),
    );
  }

  Widget _buildAddNewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddProductPage(token: widget.token),
          ),
        ).then((added) {
          if (added == true) _load();  // refresh list after returning
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 100,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 32, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                'Add New Product',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
