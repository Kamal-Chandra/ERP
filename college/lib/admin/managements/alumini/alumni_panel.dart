import 'package:flutter/material.dart';
import 'add_alumni.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlumniPanel extends StatefulWidget {
  @override
  _AlumniPanelState createState() => _AlumniPanelState();
}

class _AlumniPanelState extends State<AlumniPanel> {
  List alumniList = [];

  @override
  void initState() {
    super.initState();
    fetchAlumni();
  }

  Future<void> fetchAlumni() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/alumni'));
    if (response.statusCode == 200) {
      setState(() {
        alumniList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load alumni');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni Panel'),
      ),
      body: ListView.builder(
        itemCount: alumniList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(alumniList[index]['name']),
            subtitle: Text('Graduation Year: ${alumniList[index]['graduationYear']}\n'
                'Current Company: ${alumniList[index]['currentCompany']}\n'
                'Contact: ${alumniList[index]['contactNumber']}\n'
                'Email: ${alumniList[index]['email']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAlumniScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
