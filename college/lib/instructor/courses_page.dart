import 'package:college/instructor/Manage_course_page.dart';
import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iconsax/iconsax.dart';

class FacultyCoursesPage extends StatefulWidget {
  final int instructorId;

  FacultyCoursesPage({Key? key, required this.instructorId}) : super(key: key);

  @override
  _FacultyCoursesPageState createState() => _FacultyCoursesPageState();
}

class _FacultyCoursesPageState extends State<FacultyCoursesPage> {
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
        Uri.parse(
            'http://localhost:3000/instructors/${widget.instructorId}/courses'),
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
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
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
                              'Student Strength: ${course['student_strength']}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            tileColor: Colors.grey[800],
                            contentPadding: const EdgeInsets.all(10),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Colors.blueAccent),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageCoursePage(
                                        courseId: course['course_id']),
                                  ),
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
