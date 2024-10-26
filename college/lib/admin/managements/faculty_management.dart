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
            TextField(
              onChanged: (query) {
                facultyController.searchFaculty(query);
              },
              decoration: InputDecoration(
                labelText: 'Search Faculty',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                suffixIcon: IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),
              ),
            ),
            const SizedBox(height: 20),

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
                          trailing: const Icon(Iconsax.profile),
                        ),
                      );
                    },
                  );
                }

                // Show department grid when no search query is present
                if (facultyController.departments.isEmpty) {
                  return const Center(child: Text('No departments found.'));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
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
}