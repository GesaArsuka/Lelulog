import 'package:flutter/material.dart';
import 'new_sales_page.dart';
import 'product_page.dart';
import 'all_sales_page.dart';

class HomePage extends StatelessWidget {
  final String token;
  final int userId;

  const HomePage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Solid yellow header (no rounding)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 16, bottom: 8),
            color: Colors.yellow[700],
            child: Center(
              child: Text(
                'YOUR LOGISTICS COMPANION APP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Black band with logo + name
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/lelulog_logo.png',
                  height: 120,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.receipt_long,
                      label: 'All Sales',
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => AllSalesPage(token: token),
                          )
                        )
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      icon: Icons.shopping_bag,
                      label: 'Products',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                           builder: (_) => ProductCatalog(token: token),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      icon: Icons.shopping_cart,
                      label: 'New Sale',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewSalesPage(
                            token: token,
                            userId: userId,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
          {required IconData icon,
          required String label,
          required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.black, size: 24),
              ),
              const SizedBox(width: 24),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
}
