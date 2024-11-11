import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminFeedback extends StatelessWidget {
  const AdminFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GrievanceStats(),
          InquiriesReceived(),
          ContactUsSubmissions(),
        ],
      ),
    );
  }
}

class ContactUsSubmissions extends StatefulWidget {
  @override
  _ContactUsSubmissionsState createState() => _ContactUsSubmissionsState();
}

class _ContactUsSubmissionsState extends State<ContactUsSubmissions> {
  int totalSubmissions = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalSubmissions();
  }
  
  Future<void> fetchTotalSubmissions() async {
    final url = Uri.parse('http://localhost:3000/contactus-submissions-count');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalSubmissions = data['totalSubmissions'];
        });
      } else {
        // print('Failed to load submissions count');
      }
    } catch (error) {
      // print('Error fetching submissions count: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contact Us Submissions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Submissions: $totalSubmissions',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class InquiriesReceived extends StatefulWidget {
  @override
  _InquiriesReceivedState createState() => _InquiriesReceivedState();
}

class _InquiriesReceivedState extends State<InquiriesReceived> {
  int totalInquiries = 0;

  @override
  void initState() {
    super.initState();
    fetchInquiriesCount();
  }

  Future<void> fetchInquiriesCount() async {
    final response = await http.get(Uri.parse('http://localhost:3000/inquiries-received'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        totalInquiries = data['totalInquiries'];
      });
    } else {
      throw Exception('Failed to load inquiries count');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Inquiries Received',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Inquiries: $totalInquiries',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class GrievanceStats extends StatefulWidget {
  @override
  _GrievanceStatsState createState() => _GrievanceStatsState();
}

class _GrievanceStatsState extends State<GrievanceStats> {
  int totalPosted = 0;
  int totalOpen = 0;
  int totalClosed = 0;

  @override
  void initState() {
    super.initState();
    fetchGrievanceStats();
  }

  Future<void> fetchGrievanceStats() async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/grievance-stats'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        totalPosted = data['totalPosted'];
        totalOpen = data['totalOpen'];
        totalClosed = data['totalClosed'];
      });
    } else {
      throw Exception('Failed to load grievance stats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.red[300],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grievance Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text('Total Posted: $totalPosted', style: const TextStyle(color: Colors.white)),
            Text('Total Open: $totalOpen', style: const TextStyle(color: Colors.white)),
            Text('Total Closed: $totalClosed', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add the functionality for the 'Manage' button here
              },
              child: const Text('Manage'),
            ),
          ],
        ),
      ),
    );
  }
}