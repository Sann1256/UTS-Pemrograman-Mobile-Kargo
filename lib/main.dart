import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const CargoFlowApp());
}

class CargoFlowApp extends StatelessWidget {
  const CargoFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CargoFlow Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LoginScreen(),
    );
  }
}
