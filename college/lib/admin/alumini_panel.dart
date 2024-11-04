import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlumniPanel extends StatefulWidget {
  @override
  _AlumniPanelState createState() => _AlumniPanelState();
}

class _AlumniPanelState extends State<AlumniPanel> {
  List alumniList = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAlumni();
  }

  Future<void> fetchAlumni() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/alumni'));

    if (response.statusCode == 200) {
      setState(() {
        alumniList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load alumni');
    }
  }

  Future<void> addAlumni() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/alumni'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'graduationYear': _yearController.text,
        'currentCompany': _companyController.text,
        'contactNumber': _contactController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 201) {
      fetchAlumni();
      clearForm();
      Navigator.pop(context);
    } else {
      throw Exception('Failed to add alumni');
    }
  }

  Future<void> updateAlumni(int id) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/alumni/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'graduationYear': _yearController.text,
        'currentCompany': _companyController.text,
        'contactNumber': _contactController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      fetchAlumni();
      clearForm();
      Navigator.pop(context);
    } else {
      throw Exception('Failed to update alumni');
    }
  }

  Future<void> deleteAlumni(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/alumni/$id'),
    );

    if (response.statusCode == 204) {
      fetchAlumni();
    } else {
      throw Exception('Failed to delete alumni');
    }
  }

  void clearForm() {
    _nameController.clear();
    _yearController.clear();
    _companyController.clear();
    _contactController.clear();
    _emailController.clear();
  }

  void showFormDialog([int? id]) {
    if (id != null) {
      final alumni = alumniList.firstWhere((element) => element['id'] == id);
      _nameController.text = alumni['name'];
      _yearController.text = alumni['graduationYear'].toString();
      _companyController.text = alumni['currentCompany'] ?? '';
      _contactController.text = alumni['contactNumber'] ?? '';
      _emailController.text = alumni['email'] ?? '';
    } else {
      clearForm();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Alumni' : 'Edit Alumni'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Graduation Year'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the graduation year';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(labelText: 'Current Company'),
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (id == null) {
                    addAlumni();
                  } else {
                    updateAlumni(id);
                  }
                }
              },
              child: Text(id == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
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
        title: Text('Alumni Panel'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showFormDialog(),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: alumniList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Text(
                  alumniList[index]['name'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Graduated: ${alumniList[index]['graduationYear']}\nCompany: ${alumniList[index]['currentCompany']}\nContact: ${alumniList[index]['contactNumber']}\nEmail: ${alumniList[index]['email']}',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => showFormDialog(alumniList[index]['id']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteAlumni(alumniList[index]['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
