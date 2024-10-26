import 'package:get/get.dart';
import 'package:college/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:college/instructor/update_marks.dart';
import 'package:college/instructor/instructor_controller.dart';

class InstructorDashboard extends StatelessWidget {
  const InstructorDashboard({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final instructorController = Get.put(InstructorController());
    instructorController.fetchInstructorData(id);
    return Scaffold(
      appBar: const TAppBar(title: Text('Instructor Dashboard'), showBackArrow: true),
      body: Container(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: TSizes.buttonWidth * 5,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructor Details Section
                Obx(() => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${instructorController.instructorName.value}',
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text('ID: ${instructorController.instructorId.value}',
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text('Department: ${instructorController.department.value}',
                                style: Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Courses Section
                Obx(() => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Courses:', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: TSizes.sm),
                            if (instructorController.courses.isNotEmpty)
                              Column(
                                children: instructorController.courses.map((course) {
                                  return ListTile(
                                    title:Text('${course['course_id']}: ${course['course_name']}'),
                                  );
                                }).toList(),
                              )
                            else
                              Text('No courses available',
                                  style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Buttons Exam Schedule, and Update Marks
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('View Exam Schedule'),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ElevatedButton(
                        onPressed: () => Get.to(() => const UpdateMarksPage()),
                        child: const Text('Update Marks'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}