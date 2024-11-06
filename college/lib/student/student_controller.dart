import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StudentController extends GetxController {
  var studentName = ''.obs;
  var studentId = 0.obs;
  var courses = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchStudentData(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/students/$id')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          _parseStudentData(data[0]);
          _parseCourseData(data);
        } else {
          studentName.value = 'No data available';
          courses.clear();
        }
      } else {
        throw Exception('Failed to load student data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: ${e.toString()}';
      studentName.value = 'Error fetching data';
      courses.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void _parseStudentData(Map<String, dynamic> student) {
    studentId.value = student['id'];
    studentName.value = '${student['firstName']} ${student['lastName']}';
  }

  void _parseCourseData(List<dynamic> data) {
    courses.value = data.map((course) => {
      'course_id': course['course_id'],
      'course_name': course['course_name'],
      'marks': course['marks'],
    }).toList();
  }
}
