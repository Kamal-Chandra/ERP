import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:college/student/student_controller.dart';
import 'package:college/student/courses_page.dart';
import 'package:college/student/fees_page.dart';
import 'package:college/student/exam_schedule_page.dart';
import 'package:college/student/library_page.dart';
import 'package:college/student/hostel_page.dart';
import 'package:college/student/feedback_page.dart';

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
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),

                const SizedBox(height: 16),

                Obx(() {
                  return Column(
                    children: [
                      Text(
                        'Name: ${studentController.studentName.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Roll No: ${studentController.studentId.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const Divider(color: Colors.grey),
                    ],
                  );
                }),

                // Sidebar options
                _buildSidebarItem("Courses", Icons.book, 0),
                _buildSidebarItem("Fees", Icons.money, 1),
                _buildSidebarItem("Exam Schedule", Icons.schedule, 2),
                _buildSidebarItem("Library", Icons.library_books, 3),
                _buildSidebarItem("Hostel", Icons.home, 4),
                _buildSidebarItem("Feedback", Icons.feedback, 5),
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
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
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
