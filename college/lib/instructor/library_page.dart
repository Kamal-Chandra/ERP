import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iconsax/iconsax.dart';

class FacultyLibraryPage extends StatefulWidget {
  final int instructorId;

  FacultyLibraryPage({required this.instructorId});

  @override
  _FacultyLibraryPageState createState() => _FacultyLibraryPageState();
}

class _FacultyLibraryPageState extends State<FacultyLibraryPage> {
  List<dynamic> issuedBooks = [];
  List<dynamic> filteredBooks = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchIssuedBooks();
    _searchController.addListener(() {
      filterBooks(_searchController.text);
    });
  }

  Future<void> fetchIssuedBooks() async {
    final url = Uri.parse(
        'http://localhost:3000/instructors/${widget.instructorId}/books');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          issuedBooks = data is List ? data : [];
          filteredBooks = issuedBooks;
          isLoading = false;
          errorMessage = issuedBooks.isEmpty ? 'No books issued.' : '';
        });
      } else {
        if (response.statusCode == 404) {
          final responseData = json.decode(response.body);
          setState(() {
            errorMessage = responseData['message'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage =
                'Failed to load books (Status: ${response.statusCode}).';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data. Please try again.';
        isLoading = false;
      });
    }
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks = issuedBooks.where((book) {
        final title = book['title'].toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const Text("Library", style: TextStyle(color: TColors.primary)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search books',
                  prefixIcon: const Icon(Iconsax.search_normal, color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(errorMessage,
                              style: const TextStyle(fontSize: 18, color: Colors.white)))
                      : filteredBooks.isEmpty
                          ? const Center(
                              child: Text("No books issued.",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredBooks.length,
                                itemBuilder: (context, index) {
                                  final book = filteredBooks[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      title: Text(
                                        book['title'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'Author: ${book['author']} \nIssued on: ${book['issue_date']}',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      tileColor: Colors.grey[800],
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
