import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exam_schedule_controller.dart';
import 'package:college/app_bar.dart';
import 'package:college/utils/constants/sizes.dart';

class ExamSchedulePage extends StatelessWidget {
  final int studentId;
  final ExamScheduleController controller = Get.put(ExamScheduleController());

  ExamSchedulePage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    controller.fetchExamSchedule(studentId);

    return Scaffold(
      appBar: const TAppBar(title: Text('Exam Schedule'), showBackArrow: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return const Center(child: Text('Failed to load exam schedule.'));
        }

        return ListView.builder(
          itemCount: controller.schedule.length,
          itemBuilder: (context, index) {
            final exam = controller.schedule[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.xs),
              child: Card(
                child: ListTile(
                  title: Text(exam['course']!),
                  subtitle: Text('Date: ${exam['date']}'),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}