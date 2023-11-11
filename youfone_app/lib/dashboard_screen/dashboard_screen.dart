import 'package:flutter/material.dart';
import '../models/data.dart';
import '../styles/colors.dart';

class DashboardScreen extends StatefulWidget {
  final Data youfoneData;
  const DashboardScreen({super.key, required this.youfoneData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Data youfoneData;

  @override
  void initState() {
    youfoneData = widget.youfoneData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${youfoneData.loginResponse.object.customer.firstName} ${youfoneData.loginResponse.object.customer.lastName}',
          style: const TextStyle(color: youfoneColor, fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
