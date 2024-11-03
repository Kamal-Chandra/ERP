import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      print('Error fetching courses: $e');
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
          title: const Text("Courses", style: TextStyle(color: Colors.white)),
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
                hintText: 'Search courses',
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
            _isLoading
                ? Center(child: CircularProgressIndicator())
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Instructor: ${course['instructor_name']} \nMarks: ${course['marks'] != null ? course['marks'].toString() : 'N/A'}',
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
