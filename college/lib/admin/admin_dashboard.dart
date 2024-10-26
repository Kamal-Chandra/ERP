import 'package:get/get.dart';
import 'package:college/app_bar.dart';
import 'package:flutter/material.dart';
import 'managements/admin_feedback.dart';
import 'managements/fee/fee_management.dart';
import 'managements/admin_placement.dart';
import 'managements/hostel_management.dart';
import 'managements/faculty_management.dart';
import 'managements/student_management.dart';
import 'managements/library_management.dart';
import 'package:college/admin/widgets/admin_sidebar.dart';

class AdminDashboardController extends GetxController {
  var currentView = 'Dashboard'.obs;
  void setCurrentView(String view) {
    currentView.value = view;
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key, required id});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController dashboardController = Get.put(AdminDashboardController());

    return Scaffold(
      appBar: const TAppBar(title: Text('Admin Panel'), showBackArrow: true),
      body: Row(
        children: [
          // Sidebar
          const AdminSideBar(),

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