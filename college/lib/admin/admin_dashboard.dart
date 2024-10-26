import 'dart:convert';
import 'package:get/get.dart';
import 'package:college/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'managements/admin_feedback.dart';
import 'managements/admin_placement.dart';
import 'managements/hostel_management.dart';
import 'managements/faculty_management.dart';
import 'managements/student_management.dart';
import 'managements/library_management.dart';
import 'managements/fee/fee_management.dart';
import 'package:college/admin/widgets/admin_sidebar.dart';

class AdminDashboardController extends GetxController {
  var currentView = 'Dashboard'.obs;
  var adminName = ''.obs;
  var adminEmail = ''.obs;

  Future<void> fetchAdminDetails(String adminId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/get-admin/$adminId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        adminName.value = '${data['firstName'] ?? 'No Name'} ${data['lastName'] ?? ''}';
        adminEmail.value = data['email'] ?? 'No Email';
      } else {
        Get.snackbar('Error', 'Failed to fetch admin details');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching admin details: $e');
    }
  }

  void setCurrentView(String view) {
    currentView.value = view;
  }
}

class AdminDashboard extends StatelessWidget {
  final String adminId;

  const AdminDashboard({super.key, required this.adminId});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController dashboardController = Get.put(AdminDashboardController());

    // Fetch admin details on initialization
    dashboardController.fetchAdminDetails(adminId);

    return Scaffold(
      appBar: const TAppBar(title: Text('Admin Panel'), showBackArrow: true),
      body: Row(
        children: [
          // Sidebar
          Obx(()=>AdminSideBar(
            id: adminId,
            adminEmail: dashboardController.adminEmail.value,
            adminName: dashboardController.adminName.value,
          )),

          // Content
          Expanded(
            child: Obx(() {
              switch (dashboardController.currentView.value) {
                case 'Dashboard':
                  return const StudentManagement();
                case 'Student':
                  return const StudentManagement();
                case 'Faculty':
                  return const FacultyManagement();
                case 'Fees':
                  return FeeManagement();
                case 'Library':
                  return const LibraryManagement();
                case 'Hostel':
                  return const HostelManagement();
                case 'Feedback':
                  return const AdminFeedback();
                case 'Placements':
                  return const AdminPlacement();
                case 'Alumni':
                  // return const AlumniNetwork();
                default:
                  return const Center(child: Text('Admin Panel'));
              }
            }),
          ),
        ],
      ),
    );
  }
}