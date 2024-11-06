import 'package:college/utils/constants/colors.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iconsax/iconsax.dart';

class FacultyManagement extends StatelessWidget {
  const FacultyManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminFacultyController facultyController = Get.put(AdminFacultyController());

    return Scaffold(
      appBar: AppBar(title: const Text('Faculty Management', style: TextStyle(color: TColors.primary)), centerTitle: true),
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
                      facultyController.searchFaculty(query);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Faculty',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      suffixIcon: IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                IconButton(
                  icon: const Icon(Iconsax.refresh, color: Colors.white),
                  onPressed: () => facultyController.fetchDepartments(),
                ),
              ],
            ),

            // Display Departments or Search Results
            Expanded(
              child: Obx(() {
                if (facultyController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show search results if there's a search query
                if (facultyController.searchQuery.isNotEmpty) {
                  if (facultyController.faculty.isEmpty) {
                    return const Center(child: Text('No faculty found.'));
                  }

                  // Display faculty search results as a list of cards
                  return ListView.builder(
                    itemCount: facultyController.faculty.length,
                    itemBuilder: (context, index) {
                      final faculty = facultyController.faculty[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text('${faculty['firstName']} ${faculty['lastName']}',
                              style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text('ID: ${faculty['id']}\nDepartment: ${faculty['department']}',
                              style: Theme.of(context).textTheme.titleMedium),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Iconsax.info_circle),
                                onPressed: () {
                                  facultyController.fetchFacultyDetails(faculty['id']).then((details) {
                                    _showFacultyDetailsDialog(context, details);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.edit),
                                onPressed: () {_showEditFacultyDialog(context, facultyController, faculty);},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (facultyController.departments.isEmpty) {
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
                    itemCount: facultyController.departments.length,
                    itemBuilder: (context, index) {
                      final department = facultyController.departments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
                        child: ListTile(
                          title: Text(department['name'], style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text('Faculty Count: ${department['faculty_count']}', style: Theme.of(context).textTheme.titleMedium),
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
          _showNewFacultyDialog(context, facultyController);
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showNewFacultyDialog(BuildContext context, AdminFacultyController facultyController) {
    final idController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final departmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Faculty Member"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: idController, decoration: const InputDecoration(labelText: "ID")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: departmentController, decoration: const InputDecoration(labelText: "Department Code")),
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
                facultyController.addFaculty(
                  int.parse(idController.text),
                  firstNameController.text,
                  lastNameController.text,
                  departmentController.text,
                );
                Get.back();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

void _showEditFacultyDialog(BuildContext context, AdminFacultyController facultyController, Map<String, dynamic> faculty) {
    final firstNameController = TextEditingController(text: faculty['firstName']);
    final lastNameController = TextEditingController(text: faculty['lastName']);
    final departmentController = TextEditingController(text: faculty['department']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Faculty Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: departmentController, decoration: const InputDecoration(labelText: "Department Code")),
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
                facultyController.updateFaculty(
                  faculty['id'],
                  firstNameController.text,
                  lastNameController.text,
                  departmentController.text,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

void _showFacultyDetailsDialog(BuildContext context, Map<String, dynamic> details) {
  List<dynamic> courses = details['courses'] != null 
      ? details['courses'].split(',').map((course) => course.trim()).toList() 
      : [];
  String coursesString = courses.isNotEmpty? courses.join('\n'): "None";
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "${details['firstName']} ${details['lastName']}",
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "ID: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    TextSpan(text: "${details['id']}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Department:\n", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    TextSpan(text: "${details['department']}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.sm),
              const Text(
                  "Courses:",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                ),
              Text(coursesString, style: const TextStyle(fontSize: 14.0)),
              const SizedBox(height: TSizes.sm),
              const Text(
                "Issued Books:",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
              ),
              details['issuedBooks'] != null && details['issuedBooks'].isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: details['issuedBooks'].map<Widget>((book) {
                        return Text(
                          "${book['title']}",
                          style: const TextStyle(fontSize: 14.0),
                        );
                      }).toList(),
                    )
                  : const Text("None", style: TextStyle(fontSize: 14.0)),
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


class AdminFacultyController extends GetxController {
  var departments = <Map<String, dynamic>>[].obs;
  var faculty = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }

  // Fetch department data with faculty counts
  Future<void> fetchDepartments() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/departments-with-faculty'));
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

  // Search faculty based on ID, name, or department
  Future<void> searchFaculty(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      faculty.clear();
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/search-faculty?query=$query'));
      if (response.statusCode == 200) {
        List<dynamic> facultyData = json.decode(response.body);
        faculty.assignAll(facultyData.map((e) => e as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load faculty data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchFacultyDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/faculty/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        Get.snackbar('Error', 'Failed to load faculty details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
    return {};
  }

  Future<void> updateFaculty(int id, String firstName, String lastName, String department) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/faculty/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'department': department,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Faculty member updated successfully');
        fetchDepartments();
      } else {
        Get.snackbar('Error', 'Failed to update faculty member');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  Future<void> addFaculty(int id, String firstName, String lastName, String department) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/faculty/new'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "firstName": firstName,
          "lastName": lastName,
          "department": department,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Faculty added successfully");
        fetchDepartments();
      } else {
        Get.snackbar("Error", "Failed to add faculty");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server");
    }
  }
}