import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InstructorController extends GetxController {
  var instructorName = ''.obs;
  var instructorId = 0.obs;
  var department = ''.obs;
  var courses = <Map<String, dynamic>>[].obs;

  Future<void> fetchInstructorData(int id) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/instructors/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data.isNotEmpty) {
          // Extract instructor details
          instructorName.value = '${data['firstName']} ${data['lastName']}';
          instructorId.value = data['id'];
          department.value = data['department'];

          // Extract and update courses
          if (data['courses'] != null && data['courses'].isNotEmpty) {
            courses.value = List<Map<String, dynamic>>.from(
              data['courses'].map((course) {
                return {
                  'course_id': course['id'],
                  'course_name': course['name'],
                };
              }).toList(),
            );
          } else {
            courses.clear();
          }
        } else {
          instructorName.value = 'No data available';
          courses.clear();
        }
      } else {
        instructorName.value = 'Failed to load data';
        courses.clear();
      }
    } catch (e) {
      instructorName.value = 'Error fetching data';
      courses.clear();
    }
  }
}