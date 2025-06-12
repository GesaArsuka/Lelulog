import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductDetailsPage(),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int stockCount = 20;
  double price = 75000.00;
  String topNotes = 'Vanilla, ginger';
  String middleNotes = 'Cardamom';
  String baseNotes = 'Citrus';
  String discount = '10%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (Place Holder)
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Product Name
            Text(
              'Hugo Boss V12',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            
            // Price
            Text(
              'Rp $price',
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            
            // Top Notes Field
            Text('Top Notes'),
            TextField(
              controller: TextEditingController(text: topNotes),
              decoration: InputDecoration(hintText: 'Enter top notes'),
              onChanged: (value) {
                setState(() {
                  topNotes = value;
                });
              },
            ),
            SizedBox(height: 10),
            
            // Middle Notes Field
            Text('Middle Notes'),
            TextField(
              controller: TextEditingController(text: middleNotes),
              decoration: InputDecoration(hintText: 'Enter middle notes'),
              onChanged: (value) {
                setState(() {
                  middleNotes = value;
                });
              },
            ),
            SizedBox(height: 10),
            
            // Base Notes Field
            Text('Base Notes'),
            TextField(
              controller: TextEditingController(text: baseNotes),
              decoration: InputDecoration(hintText: 'Enter base notes'),
              onChanged: (value) {
                setState(() {
                  baseNotes = value;
                });
              },
            ),
            SizedBox(height: 20),
            
            // Discount Dropdown
            Text('Discount'),
            DropdownButton<String>(
              value: discount,
              onChanged: (String? newValue) {
                setState(() {
                  discount = newValue!;
                });
              },
              items: <String>['10%', '20%']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            
            // Stock Count
            Row(
              children: [
                Text('Stocks:'),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (stockCount > 0) stockCount--;
                    });
                  },
                ),
                Text('$stockCount'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      stockCount++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Save Button
            ElevatedButton(
              onPressed: () {
                // Save functionality
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
} 