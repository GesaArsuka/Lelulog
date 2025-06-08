import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const LelulogApp());
}

class LelulogApp extends StatelessWidget {
  const LelulogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lelulog',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
