import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../models/transaction.dart';
import '../services/transaction_api.dart';

class AllSalesPage extends StatefulWidget {
  final String token;
  const AllSalesPage({Key? key, required this.token}) : super(key: key);

  @override
  _AllSalesPageState createState() => _AllSalesPageState();
}

class _AllSalesPageState extends State<AllSalesPage> {
  bool _loading = true;
  List<Transaction> _txns = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await TransactionApi.fetchTransactions(widget.token);
      setState(() {
        _txns = list;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load sales')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(
      appBar: _buildAppBar(),
      body: Center(child: CircularProgressIndicator()),
    );

    // Group by date
    final Map<String, List<Transaction>> byDate = {};
    for (var tx in _txns) {
      byDate.putIfAbsent(tx.formattedDate, () => []).add(tx);
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: byDate.entries.expand((entry) {
            final date = entry.key;
            final txs  = entry.value;
            return [
              // date header
              Container(
                width: double.infinity,
                color: Colors.yellow[700],
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  date,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // each transaction card
              ...txs.map(_buildTxnCard).toList(),
            ];
          }).toList(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('All Sales', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      backgroundColor: Colors.yellow[700],
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  Widget _buildTxnCard(Transaction tx) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Sale #ID row
          Row(children: [
            Icon(Icons.info_outline, color: Colors.grey[700]),
            SizedBox(width: 8),
            Text('Sale #${tx.id}', style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          SizedBox(height: 8),

          // Items
          ...tx.items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${item.product.name}'),
                  ),
                  Text('${item.quantity} * Rp ${item.product.price.toStringAsFixed(0)},-'),
                  SizedBox(width: 12),
                  Text('Rp ${item.subtotal.toStringAsFixed(0)},-'),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Dash(
                direction: Axis.horizontal,
                length: constraints.maxWidth,
                dashLength: 6,
                dashThickness: 1,
                dashColor: Colors.grey,
              );
            },
          ),
          // dashed divider
          

          SizedBox(height: 8),
          // Total
          Text(
            'Total : Rp ${tx.totalPrice.toStringAsFixed(0)},-',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: 12),
          // Edit button
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // TODO: implement edit record
              },
              child: Text('Edit Record'),
            ),
          ),
        ]),
      ),
    );
  }
}
