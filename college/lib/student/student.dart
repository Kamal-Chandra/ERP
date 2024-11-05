import 'package:college/utils/constants/colors.dart';
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
      FeesPage(
        studentId: widget.id,
      ),
      ExamSchedulePage(studentId: widget.id),
      LibraryPage(studentId: widget.id),
      HostelPage(studentId: widget.id),
      FeedbackPage(studentId: widget.id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 40),

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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Roll No: ${studentController.studentId.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                }),

                // Sidebar options
                _buildSidebarItem("Courses", Iconsax.bookmark, 0),
                _buildSidebarItem("Fees", Iconsax.card, 1),
                _buildSidebarItem("Exam Schedule", Iconsax.calendar, 2),
                _buildSidebarItem("Library", Iconsax.book, 3),
                _buildSidebarItem("Hostel", Iconsax.house, 4),
                _buildSidebarItem("Feedback", Iconsax.message_question, 5),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: _pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, int index) {
    return ListTile(
      hoverColor: TColors.primary,
      leading: Icon(icon, color: Colors.lightBlueAccent),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
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
