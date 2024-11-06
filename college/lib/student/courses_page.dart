import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iconsax/iconsax.dart';

class CoursesPage extends StatefulWidget {
  final int studentId;

  CoursesPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> _courses = [];
  List<dynamic> _filteredCourses = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourses();
    _searchController.addListener(() {
      filterCourses(_searchController.text);
    });
  }

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/students/${widget.studentId}/courses'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _courses = data;
          _filteredCourses = _courses;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterCourses(String query) {
    setState(() {
      _filteredCourses = _courses.where((course) {
        final courseName = course['course_name'].toLowerCase();
        return courseName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const Text("Courses", style: TextStyle(color: TColors.primary)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses',
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
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              course['course_name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Instructor: ${course['instructor_name']} \nMarks: ${course['marks'] != null ? course['marks'].toString() : 'N/A'}',
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
    );
  }
}
