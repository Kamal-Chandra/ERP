import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;

  StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
