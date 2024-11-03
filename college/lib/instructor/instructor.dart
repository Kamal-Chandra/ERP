import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:college/instructor/instructor_controller.dart';
import 'package:college/instructor/courses_page.dart';
import 'package:college/instructor/library_page.dart';
import 'package:college/instructor/feedback_page.dart';

class InstructorDashboard extends StatefulWidget {
  final int id;

  const InstructorDashboard({Key? key, required this.id}) : super(key: key);

  @override
  _InstructorDashboardState createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  final InstructorController instructorController =
      Get.put(InstructorController());
  int selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    instructorController.fetchInstructorData(widget.id);

    _pages = [
      FacultyCoursesPage(instructorId: widget.id),
      FacultyLibraryPage(instructorId: widget.id),
      FacultyFeedbackPage(facultyId: widget.id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
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
                        'Name: ${instructorController.instructorName.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: ${instructorController.instructorId.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const Divider(color: Colors.grey),
                    ],
                  );
                }),
                _buildSidebarItem("Courses", Icons.book, 0),
                _buildSidebarItem("Library", Icons.library_books, 1),
                _buildSidebarItem("Feedback", Icons.feedback, 2),
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
