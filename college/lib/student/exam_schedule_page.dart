import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class ExamSchedulePage extends StatefulWidget {
  final int studentId;

  ExamSchedulePage({required this.studentId});

  @override
  _ExamSchedulePageState createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  List<Map<String, dynamic>> _examSchedule = [];
  List<Map<String, dynamic>> _filteredExamSchedule = [];
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchExamSchedule();
    _searchController.addListener(() {
      filterExamSchedule(_searchController.text);
    });
  }

  Future<void> fetchExamSchedule() async {
    final url = Uri.parse(
        'http://localhost:3000/students/${widget.studentId}/exam-schedule');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _examSchedule = List<Map<String, dynamic>>.from(data);
          _filteredExamSchedule = _examSchedule;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void filterExamSchedule(String query) {
    setState(() {
      _filteredExamSchedule = _examSchedule.where((schedule) {
        final courseName = schedule['course_name']?.toLowerCase() ?? '';
        return courseName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const Text('Exam Schedule',
              style: TextStyle(color: TColors.primary)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text('Failed to load exam schedule.',
                      style: TextStyle(color: Colors.white)))
              : _filteredExamSchedule.isEmpty
                  ? const Center(
                      child: Text('No exams scheduled.',
                          style: TextStyle(color: Colors.white)))
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search exams',
                                prefixIcon:
                                    const Icon(Iconsax.search_normal, color: Colors.white),
                                hintStyle: const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              itemCount: _filteredExamSchedule.length,
                              itemBuilder: (context, index) {
                                final schedule = _filteredExamSchedule[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: ListTile(
                                    title: Text(
                                      schedule['course_name'] ?? 'N/A',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Date: ${schedule['exam_date'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    tileColor: Colors.black,
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
