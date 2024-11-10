import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAlumniScreen extends StatelessWidget {
  final TextEditingController idController =
      TextEditingController(); // New ID controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController graduationYearController =
      TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> addAlumni() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/alumni'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': idController.text, // Manually set ID
        'name': nameController.text,
        'graduationYear': int.parse(graduationYearController.text),
        'currentCompany': companyController.text,
        'contactNumber': contactController.text,
        'email': emailController.text,
      }),
    );
    if (response.statusCode == 200) {
      print('Alumni added successfully');
    } else {
      print('Failed to add alumni');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Alumni')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: idController,
                decoration:
                    InputDecoration(labelText: 'Student ID')), // ID input field
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name')),
            TextField(
                controller: graduationYearController,
                decoration: InputDecoration(labelText: 'Graduation Year')),
            TextField(
                controller: companyController,
                decoration: InputDecoration(labelText: 'Current Company')),
            TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact Number')),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email')),
            ElevatedButton(onPressed: addAlumni, child: Text('Add Alumni')),
          ],
        ),
      ),
    );
  }
}
