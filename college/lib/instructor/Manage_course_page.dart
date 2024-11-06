import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iconsax/iconsax.dart';

class ManageCoursePage extends StatefulWidget {
  final int courseId;

  ManageCoursePage({Key? key, required this.courseId}) : super(key: key);

  @override
  _ManageCoursePageState createState() => _ManageCoursePageState();
}

class _ManageCoursePageState extends State<ManageCoursePage> {
  List<dynamic> _students = [];
  List<dynamic> _filteredStudents = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _enrollStudentController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEnrolledStudents();
    _searchController.addListener(() {
      filterStudents(_searchController.text);
    });
  }

  Future<void> fetchEnrolledStudents() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/courses/${widget.courseId}/students'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _students = data;
        _filteredStudents = _students; 
        _isLoading = false;
      });
    } else {
      print('Failed to fetch students');
    }
  }

  Future<void> enrollStudent() async {
    final studentId = _enrollStudentController.text;
    final response = await http.post(
      Uri.parse(
          'http://localhost:3000/courses/${widget.courseId}/enroll-student'),
      body: json.encode({'studentId': int.parse(studentId)}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      fetchEnrolledStudents(); 
      _enrollStudentController.clear();
    } else {
      print('Failed to enroll student');
    }
  }

  Future<void> updateStudentMarks(int studentId, int newMarks) async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:3000/courses/${widget.courseId}/students/$studentId/marks'),
      body: json.encode({'marks': newMarks}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      fetchEnrolledStudents();
    } else {
      print('Failed to update marks');
    }
  }

  void filterStudents(String query) {
    setState(() {
      _filteredStudents = _students.where((student) {
        final studentName = student['name'].toLowerCase();
        return studentName.contains(query.toLowerCase());
      }).toList();
    });
  }

  void showUpdateMarksDialog(int studentId, int? currentMarks) {
    final TextEditingController _marksController = TextEditingController();
    _marksController.text = (currentMarks ?? 'N/A').toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Marks'),
          content: TextField(
            controller: _marksController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter new marks',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newMarks = int.tryParse(_marksController.text);
                if (newMarks != null) {
                  updateStudentMarks(studentId, newMarks);
                  Navigator.pop(context);
                } else {
                  print('Invalid marks entered');
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Manage Course", style: TextStyle(color: TColors.primary)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Iconsax.arrow_left, color: TColors.primary)),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search students',
                prefixIcon: const Icon(Iconsax.search_normal, color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white),
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
            TextField(
              controller: _enrollStudentController,
              decoration: InputDecoration(
                labelText: 'Enter Student ID to Enroll',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.add),
                  onPressed: enrollStudent,
                  color: Colors.white,
                ),
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
                      itemCount: _filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = _filteredStudents[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              student['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'ID: ${student['id']}, Marks: ${student['marks'] != null ? student['marks'].toString() : 'N/A'}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            tileColor: Colors.grey[800],
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            trailing: IconButton(
                              icon: const Icon(Iconsax.edit, color: Colors.white),
                              onPressed: () {
                                showUpdateMarksDialog(
                                    student['id'], student['marks']);
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
