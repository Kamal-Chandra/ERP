import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        print(errorMessage);
      }
    } catch (e) {
      print('Error fetching books: $e');
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
          title: const Text("Library", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books',
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(errorMessage,
                            style: TextStyle(fontSize: 18, color: Colors.red)))
                    : filteredBooks.isEmpty
                        ? Center(
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
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Author: ${book['author']} \nIssued on: ${book['issue_date']}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    tileColor: Colors.grey[800],
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
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
