import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class TotalInventoryScreen extends StatefulWidget {
  @override
  _TotalInventoryScreenState createState() => _TotalInventoryScreenState();
}

class _TotalInventoryScreenState extends State<TotalInventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _totalCopiesController = TextEditingController();
  final TextEditingController _copiesAvailableController = TextEditingController();

  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchBooks(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _totalCopiesController.dispose();
    _copiesAvailableController.dispose();
    super.dispose();
  }

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final response = await http.get(Uri.parse('http://localhost:3000/books/search?query=$query'));
    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<void> _addBook() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/books/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': _titleController.text,
        'author': _authorController.text,
        'isbn': _isbnController.text,
        'total_copies': int.parse(_totalCopiesController.text),
        'copies_available': int.parse(_copiesAvailableController.text),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book added successfully')));
      _titleController.clear();
      _authorController.clear();
      _isbnController.clear();
      _totalCopiesController.clear();
      _copiesAvailableController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add book')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Iconsax.arrow_left, color: TColors.primary)),
      ),
      body: Column(
        children: [
          Card(
            color: Colors.blue,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: ListTile(
                title: const Text(
                  'Total Inventory',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Search Books'),
                            content: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search by any attribute',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text('Manage'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Add New Book'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _authorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Author',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _isbnController,
                                  decoration: const InputDecoration(
                                    labelText: 'ISBN',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _totalCopiesController,
                                  decoration: const InputDecoration(
                                    labelText: 'Total Copies',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _copiesAvailableController,
                                  decoration: const InputDecoration(
                                    labelText: 'Copies Available',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  _addBook();
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                child: const Text('Add'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Author: ${item['author'] ?? ''}'),
                        Text('ISBN: ${item['isbn'] ?? ''}'),
                        Text('Total Copies: ${item['total_copies']}'),
                        Text('Copies Available: ${item['copies_available']}'),
                      ],
                    ),
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