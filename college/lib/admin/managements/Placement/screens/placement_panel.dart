import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';

class PlacementPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placement Panel')),
      body: Column(
        children: [
          Row(
            children: [
              StatCard(title: 'Total Students', value: '600'),
              StatCard(title: 'Total Applications', value: '1400'),
              StatCard(title: 'Shortlisted', value: '46'),
              StatCard(title: 'Recruited', value: '0'),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Student $index'),
                  subtitle: const Text('Status: Applied'),
                  trailing: DropdownButton<String>(
                    value: 'applied',
                    items: const [
                      DropdownMenuItem(value: 'applied', child: Text('Applied')),
                      DropdownMenuItem(value: 'shortlisted', child: Text('Shortlisted')),
                      DropdownMenuItem(value: 'recruited', child: Text('Recruited')),
                    ],
                    onChanged: (value) {
                      // Update status
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
