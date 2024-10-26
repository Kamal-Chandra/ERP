import 'package:flutter/material.dart';
import 'package:college/app_bar.dart';
import 'package:college/utils/constants/sizes.dart';

class InstructorCoursesPage extends StatelessWidget {
  const InstructorCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example: Fetch courses from a service or database
    final List<String> courses = ['Algorithms', 'Data Structures', 'AI & ML']; // Replace with actual fetch logic

    return Scaffold(
      appBar: const TAppBar(
        title: Text('Your Courses'),
        showBackArrow: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(TSizes.md),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(courses[index]),
            ),
          );
        },
      ),
    );
  }
}