import 'dart:convert';
import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

import 'inventory.dart';


class LibraryManagement extends StatefulWidget {
  @override
  _LibraryManagementState createState() => _LibraryManagementState();
}

class _LibraryManagementState extends State<LibraryManagement> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _returnDateController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> _searchResults = [];

  // Search function to get the issued books
  void _search() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/search?issuer_id=$_searchQuery'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body);
      });
    } else {
      // print('Failed to load search results: ${response.statusCode}');
    }
  }

  // Function to add the return date
  void _addReturnDate(int issueId) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/add-return-date'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'issue_id': issueId,
        'return_date': _returnDateController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Update UI or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Return date updated successfully')),
      );
      _returnDateController.clear(); // Clear input field
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update return date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
        actions: [
          IconButton(onPressed: ()=>Get.to(()=>TotalInventoryScreen()), icon: const Icon(Iconsax.book_saved, color: TColors.primary))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by Issuer ID",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                    });
                    _search();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var result = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Issue ID: ${result['issue_id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Issuer ID: ${result['issuer_id']}'),
                          Text('Date of Issue: ${result['date_of_issue']}'),
                          result['date_of_return'] != null
                              ? Text('Date of Return: ${result['date_of_return']}')
                              : const Text('Return Date: Not Set'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Add Return Date'),
                                content: TextField(
                                  controller: _returnDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter Return Date (YYYY-MM-DD)',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _addReturnDate(result['issue_id']);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}