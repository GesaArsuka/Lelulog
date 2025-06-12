import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductCatalog(),
    );
  }
}

class ProductCatalog extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'Hugo Boss V12',
      'topNotes': 'Vanilla, ginger',
      'heartNotes': 'Cardamom',
      'baseNotes': 'Citrus',
    }, 
    {
      'name': 'Sea Siren X',
      'topNotes': 'Vanilla, ginger',
      'heartNotes': 'Cardamom',
      'baseNotes': 'Citrus',
    },
    {
      'name': 'The Hunt',
      'topNotes': 'Vanilla, ginger',
      'heartNotes': 'Cardamom',
      'baseNotes': 'Citrus',
    },
    {
      'name': 'Chill Vibes',
      'topNotes': 'Vanilla, ginger',
      'heartNotes': 'Cardamom',
      'baseNotes': 'Citrus',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Catalog'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    name: products[index]['name']!,
                    topNotes: products[index]['topNotes']!,
                    heartNotes: products[index]['heartNotes']!,
                    baseNotes: products[index]['baseNotes']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String topNotes;
  final String heartNotes;
  final String baseNotes;

  ProductCard({
    required this.name,
    required this.topNotes,
    required this.heartNotes,
    required this.baseNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: Icon(Icons.image, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Top Notes: $topNotes'),
                  Text('Heart Notes: $heartNotes'),
                  Text('Base Notes: $baseNotes'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Edit action
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}