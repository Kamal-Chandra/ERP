import 'package:college/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HostelPage extends StatefulWidget {
  final int studentId;

  HostelPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _HostelPageState createState() => _HostelPageState();
}

class _HostelPageState extends State<HostelPage> {
  String roomNumber = 'Not allocated';
  List<dynamic> roommates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHostelDetails();
  }

  Future<void> fetchHostelDetails() async {
    final url =
        Uri.parse('http://localhost:3000/students/${widget.studentId}/hostel');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          roomNumber = data['room_number']?.toString()??'Not Allocated';
          roommates = List.from(data['roommates'] ?? []);
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load hostel details (Status: ${response.statusCode}).');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Hostel Details",
              style: TextStyle(color: TColors.primary)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(32.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Room Number: $roomNumber",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    roommates.isNotEmpty?"Occupants:":"",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: roommates.length,
                      itemBuilder: (context, index) {
                        final roommate = roommates[index];
                        return ListTile(
                          title: Text(
                            '${roommate['firstName']} ${roommate['lastName']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          tileColor: Colors.grey[800],
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
