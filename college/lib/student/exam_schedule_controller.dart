import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExamScheduleController extends GetxController {
  var schedule = [].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  Future<void> fetchExamSchedule(int studentId) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('http://localhost:3000/students/$studentId/exam-schedule'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        schedule.value = data.map((item) {
          return {
            'course': item['course_name'],
            'date': item['exam_date'],
          };
        }).toList();
        hasError(false);
      } else {
        hasError(true);
      }
    } catch (error) {
      hasError(true);
    } finally {
      isLoading(false);
    }
  }
}