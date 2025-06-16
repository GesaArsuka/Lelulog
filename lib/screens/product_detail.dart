import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../services/product_api.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final String token;

  const ProductDetail({
    Key? key,
    required this.product,
    required this.token,
  }) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late TextEditingController _priceController;
  late TextEditingController _topNotes;
  late TextEditingController _middleNotes;
  late TextEditingController _baseNotes;
  late int _discount;
  late int _stock;
  File? _pickedImage;
  final _picker = ImagePicker();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(0),
    );
    _topNotes = TextEditingController(text: widget.product.topNotes ?? '');
    _middleNotes = TextEditingController(text: widget.product.heartNotes ?? '');
    _baseNotes = TextEditingController(text: widget.product.baseNotes ?? '');
    _discount = widget.product.discount ?? 0;
    _stock = widget.product.stock;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _topNotes.dispose();
    _middleNotes.dispose();
    _baseNotes.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final priceVal = double.tryParse(_priceController.text) ?? widget.product.price;

    final changes = {
      'price': priceVal,
      'top_notes': _topNotes.text,
      'heart_notes': _middleNotes.text,
      'base_notes': _baseNotes.text,
      'discount': _discount,
      'stock': _stock,
    };

    try {
      final updated = await ProductApi.updateProduct(
        id: widget.product.id,
        token: widget.token,
        changes: changes,
        imageFile: _pickedImage, 
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved successfully')));
      Navigator.pop(context, updated);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Save failed')));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: _pickedImage == null
                            ? const Icon(Icons.image, size: 50, color: Colors.grey)
                            : Image.file(_pickedImage!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(widget.product.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Price', style: TextStyle(color: Colors.grey)),
                    TextField(
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        prefixText: 'Rp ',
                        suffixText: ',-',
                      ),
                    ),
                    const Divider(height: 32),
                    TextField(
                      controller: _topNotes,
                      decoration: const InputDecoration(labelText: 'Top Notes'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _middleNotes,
                      decoration: const InputDecoration(labelText: 'Middle Notes'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _baseNotes,
                      decoration: const InputDecoration(labelText: 'Base Notes'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Discount'),
                    DropdownButton<int>(
                      isExpanded: true,
                      value: _discount,
                      items: [0, 10, 20, 30]
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text('$d%'),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _discount = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Stocks', style: TextStyle(color: Colors.grey)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _stock > 0 ? () => setState(() => _stock--) : null,
                        ),
                        Text('$_stock',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => _stock++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
