import 'package:flutter/material.dart';
import '../styles/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Dashboard",
          style: TextStyle(color: youfoneColor, fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
