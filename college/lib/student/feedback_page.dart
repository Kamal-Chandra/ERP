import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackPage extends StatefulWidget {
  final int studentId;

  FeedbackPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String _status = 'unresolved';

  Future<void> submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final feedbackData = {
        'giver_id': widget.studentId,
        'subject': _subjectController.text,
        'status': _status,
        'date_posted': DateTime.now().toIso8601String().split("T")[0],
        'feedback_text': _feedbackController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:3000/student-feedback'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedbackData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Feedback submitted successfully!"),
        ));
        _subjectController.clear();
        _feedbackController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to submit feedback. Please try again."),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Feedback", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Feedback',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: submitFeedback,
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
