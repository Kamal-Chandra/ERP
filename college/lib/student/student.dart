import 'package:college/app_bar.dart';
import 'package:college/utils/constants/colors.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:college/student/student_controller.dart';
import 'package:college/student/courses_page.dart';
import 'package:college/student/fees_page.dart';
import 'package:college/student/exam_schedule_page.dart';
import 'package:college/student/library_page.dart';
import 'package:college/student/hostel_page.dart';
import 'package:college/student/feedback_page.dart';
import 'package:iconsax/iconsax.dart';

class StudentDashboard extends StatefulWidget {
  final int id;

  StudentDashboard({Key? key, required this.id}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final StudentController studentController = Get.put(StudentController());
  int selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    studentController.fetchStudentData(widget.id);

    _pages = [
      CoursesPage(studentId: widget.id),
      FeesPage(studentId: widget.id),
      ExamSchedulePage(studentId: widget.id),
      LibraryPage(studentId: widget.id),
      HostelPage(studentId: widget.id),
      FeedbackPage(studentId: widget.id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: Text('Student Panel'), showBackArrow: true),
      body: Row(
        children: [
          // Sidebar container
          Container(
            width: 250,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Profile Info
                _buildProfileSection(),

                // Sidebar options
                const SizedBox(height: TSizes.sm),
                _buildSidebarItem("Courses", Iconsax.bookmark, 0),
                const SizedBox(height: TSizes.sm),
                _buildSidebarItem("Fees", Iconsax.card, 1),
                const SizedBox(height: TSizes.sm),
                _buildSidebarItem("Exam Schedule", Iconsax.calendar, 2),
                const SizedBox(height: TSizes.sm),
                _buildSidebarItem("Library", Iconsax.book, 3),
                const SizedBox(height: TSizes.sm),
                _buildSidebarItem("Hostel", Iconsax.house, 4),
                const SizedBox(height: TSizes.sm),
                _buildSidebarItem("Feedback", Iconsax.message_question, 5),
              ],
            ),
          ),

          // Page content area
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<int>(selectedIndex),
                color: Colors.white,
                child: _pages[selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar profile info section
  Widget _buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[700],
          child: const Icon(Iconsax.user, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Obx(() {
          return Column(
            children: [
              Text(
                studentController.studentName.value,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                'Roll No: ${studentController.studentId.value}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          );
        }),
        const Divider(color: Colors.white70, thickness: 0.5, height: 40),
      ],
    );
  }

  // Sidebar item builder
  Widget _buildSidebarItem(String title, IconData icon, int index) {
    return ListTile(
      hoverColor: TColors.primary,
      leading: Icon(
        icon,
        color: selectedIndex == index ? TColors.primary : Colors.lightBlueAccent,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selectedIndex == index ? TColors.primary : Colors.white,
          fontSize: 16,
          fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selectedIndex == index,
      selectedTileColor: Colors.grey[700],
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
