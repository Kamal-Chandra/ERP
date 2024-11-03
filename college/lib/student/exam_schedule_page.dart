import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
          _filteredExamSchedule = _examSchedule; // Initialize filtered list
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
          title: const Text('Exam Schedule',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Text('Failed to load exam schedule.',
                      style: TextStyle(color: Colors.white)))
              : _filteredExamSchedule.isEmpty
                  ? Center(
                      child: Text('No exams scheduled.',
                          style: TextStyle(color: Colors.white)))
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search exams',
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            itemCount: _filteredExamSchedule.length,
                            itemBuilder: (context, index) {
                              final schedule = _filteredExamSchedule[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: ListTile(
                                  title: Text(
                                    schedule['course_name'] ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Date: ${schedule['exam_date'] ?? 'N/A'}',
                                    style: TextStyle(
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
    );
  }
}
