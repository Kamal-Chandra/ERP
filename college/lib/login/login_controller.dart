import 'package:college/admin/admin_dashboard.dart';
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

  void showSnackbar(String title, String message, {bool isSuccess = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> loginStudent(String username, String password) async {
    isLoading.value = true;
    try {
      final response = await Api.loginStudent(username, password);
      if (response.statusCode == 200) {
        final studentId = response.data['studentId'];
        showSnackbar('Success', 'Login successful', isSuccess: true);
        Get.to(() => StudentDashboard(id: studentId));
      } else {
        showSnackbar('Error', 'Login failed: ${response.data['message']}');
      }
    } catch (e) {
      showSnackbar('Error', 'An error occurred');
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
        showSnackbar('Success', 'Login successful', isSuccess: true);
        Get.to(() => InstructorDashboard(id: instructorId));
      } else {
        showSnackbar('Error', 'Login failed: ${response.data['message']}');
      }
    } catch (e) {
      showSnackbar('Error', 'An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginAdmin(String username, String password) async {
    isLoading.value = true;
    try {
      final response = await Api.loginAdmin(username, password);
      if (response.statusCode == 200) {
        final adminID = response.data['adminId'].toString();
        showSnackbar('Success', 'Login successful', isSuccess: true);
        Get.to(() => AdminDashboard(adminId: adminID));
      } else {
        showSnackbar('Error', 'Login failed: ${response.data['message']}');
      }
    } catch (e) {
      showSnackbar('Error', 'An error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}