import 'package:flutter/material.dart';
import 'package:college/app_bar.dart';
import 'package:college/utils/constants/sizes.dart';

class UpdateMarksPage extends StatelessWidget {
  const UpdateMarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example: Fetch students and their marks from a service or database
    final List<Map<String, dynamic>> studentMarks = [
      {'studentName': 'Amit Sharma', 'course': 'Algorithms', 'marks': 85},
      {'studentName': 'Sneha Verma', 'course': 'Data Structures', 'marks': 90},
      {'studentName': 'Rahul Gupta', 'course': 'AI & ML', 'marks': 78},
    ]; // Replace with actual fetch logic

    return Scaffold(
      appBar: const TAppBar(
        title: Text('Update Marks'),
        showBackArrow: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(TSizes.md),
        itemCount: studentMarks.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('${studentMarks[index]['studentName']} - ${studentMarks[index]['course']}'),
              trailing: Text('${studentMarks[index]['marks']}'),
              onTap: () {
                // Handle mark update logic here
              },
            ),
          );
        },
      ),
    );
  }
}