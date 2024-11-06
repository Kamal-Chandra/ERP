import 'dart:convert';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/colors.dart';

class CourseManagement extends StatelessWidget {
  const CourseManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController courseController = Get.put(CourseController());

    return Scaffold(
      appBar: AppBar(title: const Text('Course Management', style: TextStyle(color: TColors.primary)), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      courseController.searchCourse(query);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Course',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      suffixIcon: IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                IconButton(
                  icon: const Icon(Iconsax.refresh, color: Colors.white),
                  onPressed: () => courseController.fetchDepartmentsWithCourses(),
                ),
              ],
            ),

            // Display Departments or Search Results
            Expanded(
              child: Obx(() {
                if (courseController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (courseController.searchQuery.isNotEmpty) {
                  if (courseController.courses.isEmpty) {
                    return const Center(child: Text('No courses found.'));
                  }

                  return ListView.builder(
                    itemCount: courseController.courses.length,
                    itemBuilder: (context, index) {
                      final course = courseController.courses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(course['name'], style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text('ID: ${course['id']}\nDepartment: ${course['department']}',
                              style: Theme.of(context).textTheme.titleMedium),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Iconsax.info_circle),
                                onPressed: () {
                                  courseController.fetchCourseDetails(course['id']).then((details) {
                                    _showCourseDetailsDialog(context, details);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.edit),
                                onPressed: () {_showEditCourseDialog(context, courseController, course);},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (courseController.departments.isEmpty) {
                  return const Center(child: Text('No departments found.'));
                }

                return Padding(
                  padding: const EdgeInsets.only(top: TSizes.md),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 2.0,
                    ),
                    itemCount: courseController.departments.length,
                    itemBuilder: (context, index) {
                      final department = courseController.departments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
                        child: ListTile(
                          title: Text(department['name'], style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text('Course Count: ${department['course_count']}', style: Theme.of(context).textTheme.titleMedium),
                          trailing: const Icon(Iconsax.graph),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        onPressed: () {
          _showNewCourseDialog(context, courseController);
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showNewCourseDialog(BuildContext context, CourseController courseController) {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final departmentController = TextEditingController();
    final facultyIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Course"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: idController, decoration: const InputDecoration(labelText: "ID")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: departmentController, decoration: const InputDecoration(labelText: "Department Code")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: facultyIdController, decoration: const InputDecoration(labelText: "Faculty ID")),
              const SizedBox(height: TSizes.sm),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                courseController.addCourse(
                  int.parse(idController.text),
                  nameController.text,
                  departmentController.text,
                  int.parse(facultyIdController.text),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

void _showEditCourseDialog(BuildContext context, CourseController courseController, Map<String, dynamic> course) {
  final nameController = TextEditingController(text: course['name']);
  final departmentController = TextEditingController(text: course['department']);
  final facultyIdController = TextEditingController(text: course['instructor'].toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Course Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: TSizes.sm),
            TextField(controller: departmentController, decoration: const InputDecoration(labelText: "Department Code")),
            const SizedBox(height: TSizes.sm),
            TextField(
              controller: facultyIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Faculty ID"),
            ),
            const SizedBox(height: TSizes.sm),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              courseController.updateCourse(
                course['id'],
                nameController.text,
                departmentController.text,
                int.parse(facultyIdController.text),
              );
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}

void _showCourseDetailsDialog(BuildContext context, Map<String, dynamic> details) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          details['name'] ?? 'Course Name',
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course ID
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "ID: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    TextSpan(text: "${details['id'] ?? 'N/A'}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),
              
              // Department
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Department: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    TextSpan(text: "${details['department'] ?? 'Not Assigned'}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Faculty ID
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Faculty ID: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    TextSpan(text: "${details['facultyId'] ?? 'Not Available'}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Faculty Name
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Faculty Name: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    TextSpan(text: "${details['facultyName'] ?? 'Not Available'}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Close", style: TextStyle(fontSize: 16.0)),
          ),
        ],
      );
    },
  );
}

class CourseController extends GetxController {
  var departments = <Map<String, dynamic>>[].obs;
  var courses = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepartmentsWithCourses();
  }

  Future<void> fetchDepartmentsWithCourses() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/departments-with-courses'));
      if (response.statusCode == 200) {
        List<dynamic> departmentData = json.decode(response.body);
        departments.assignAll(departmentData.map((e) => e as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load departments');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchCourse(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      courses.clear();
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/search-courses?q=$query'));
      if (response.statusCode == 200) {
        List<dynamic> courseData = json.decode(response.body);
        courses.assignAll(courseData.map((e) => e as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load courses');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> fetchCourseDetails(int courseId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/courses/$courseId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> courseDetails = json.decode(response.body);
        return courseDetails;
      } else {
        Get.snackbar('Error', 'Failed to load course details');
        return {};
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
      return {};
    }
  }

  void addCourse(int id, String name, String department, int facultyId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/courses'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id': id,
          'name': name,
          'department': department,
          'facultyId': facultyId,
        }),
      );
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Course added successfully');
        fetchDepartmentsWithCourses();
      } else {
        Get.snackbar('Error', 'Failed to add course');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  void updateCourse(int id, String name, String department, int facultyId) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/courses/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': name,
          'department': department,
          'instructor': facultyId,
        })
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Course updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update course');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }
}