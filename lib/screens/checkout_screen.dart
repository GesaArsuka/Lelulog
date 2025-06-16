import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 

class CheckoutPage extends StatefulWidget {
  final int transactionId;
  final Map<int, int> cartItems; 
  final int totalPrice;
  final String token;

  const CheckoutPage({
    required this.transactionId,
    required this.cartItems,
    required this.totalPrice,
    required this.token,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  File? paymentProof;
  final picker = ImagePicker();
  String selectedPaymentMethod = "Cash";
  bool submitting = false;

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        paymentProof = File(picked.path);
      });
    }
  }

  Future<void> _submitTransaction() async {
    if (paymentProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload proof of payment.")),
      );
      return;
    }

    setState(() {
      submitting = true;
    });

    final uri = Uri.parse(
      'https://0b05-2404-c0-2c10-00-32f0-6f18.ngrok-free.app/api/transactions/${widget.transactionId}/finalize'
    );

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${widget.token}'
      ..fields['payment_method'] = selectedPaymentMethod;

    request.files.add(
      await http.MultipartFile.fromPath(
        'payment_proof',
        paymentProof!.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await request.send();
    setState(() {
      submitting = false;
    });

    if (streamedResponse.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction finalized successfully.")),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to finalize transaction.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Price: Rp ${widget.totalPrice}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text("Payment Method"),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              items: ['Cash', 'QRIS', 'Transfer'].map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPaymentMethod = value);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text("Proof of Payment"),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                image: paymentProof != null
                    ? DecorationImage(
                        image: FileImage(paymentProof!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: paymentProof == null
                  ? const Center(
                      child: Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Upload Image"),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: submitting ? null : _submitTransaction,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: submitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Finalize"),
        ),
      ),
    );
  }
}
