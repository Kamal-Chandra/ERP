import 'package:college/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:college/app_bar.dart';
import 'package:college/student/exam_schedule.dart';
import 'package:college/student/student_controller.dart';

class StudentDashboard extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());

  StudentDashboard({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    studentController.fetchStudentData(id);

    return Scaffold(
      appBar: const TAppBar(
        title: Text('Student Dashboard'),
        showBackArrow: true,
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: TSizes.buttonWidth*6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (studentController.studentName.value.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
          
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${studentController.studentName.value}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'ID: ${studentController.studentId.value}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: studentController.courses.length,
                      itemBuilder: (context, index) {
                        final course = studentController.courses[index];
                        return ListTile(
                          title: Text('Course: ${course['course_name']}'),
                          subtitle: Text('Marks: ${course['marks']}'),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.to(() => ExamSchedulePage(studentId: studentController.studentId.value)),
                          child: const Text('View Exam Schedule'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}