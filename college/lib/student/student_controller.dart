import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StudentController extends GetxController {
  var studentName = ''.obs;
  var studentId = 0.obs;
  var courses = <Map<String, dynamic>>[].obs;

  Future<void> fetchStudentData(int id) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/students/$id'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final studentData = {
            'id': data[0]['id'],
            'firstName': data[0]['firstName'],
            'lastName': data[0]['lastName']
          };

          final courseData = data.map((course) => {
            'course_id': course['course_id'],
            'course_name': course['course_name'],
            'marks': course['marks']
          }).toList();

          studentName.value = '${studentData['firstName']} ${studentData['lastName']}';
          studentId.value = studentData['id'];
          courses.value = courseData;
        } else {
          studentName.value = 'No data available';
          courses.clear();
        }
      } else {
        throw Exception('Failed to load student data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      studentName.value = 'Error fetching data';
      courses.clear();
    }
  }
}