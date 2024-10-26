import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:college/login/api.dart';
import 'package:college/student/student.dart';
import 'package:college/instructor/instructor.dart';

class LoginController extends GetxController {

  var isLoading = false.obs;
  var loginMessage = ''.obs;
  final hidePassword = true.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginStudent(String username, String password) async {
    isLoading.value = true;
    try {
      final response = await Api.loginStudent(username, password);
      if (response.statusCode == 200) {
        final studentId = response.data['studentId'];
        loginMessage.value = 'Login successful';
        Get.to(() => StudentDashboard(id: studentId));
      } else {
        loginMessage.value = 'Login failed: ${response.data['message']}';
      }
    } catch (e) {
      loginMessage.value = 'An error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginInstructor(String username, String password) async {
    isLoading.value = true;
    try {
      final response = await Api.loginInstructor(username, password);
      if (response.statusCode == 200) {
        final instructorId = response.data['instructorId'];
        loginMessage.value = 'Login successful';
        Get.to(() => InstructorDashboard(id: instructorId));
      } else {
        loginMessage.value = 'Login failed: ${response.data['message']}';
      }
    } catch (e) {
      loginMessage.value = 'An error occurred';
    } finally {
      isLoading.value = false;
    }
  }
}