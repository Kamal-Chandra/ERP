import 'package:flutter/material.dart';

class CompanyTile extends StatelessWidget {
  final Map<String, dynamic> company;

  CompanyTile({required this.company});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(company['name']),
      subtitle: Text('Profile: ${company['profile']}'),
      trailing: Text('Shortlisted: ${company['shortlisted']}'),
    );
  }
}
