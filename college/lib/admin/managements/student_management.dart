import 'dart:convert';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/colors.dart';

class StudentManagement extends StatelessWidget {
  const StudentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminStudentController studentController = Get.put(AdminStudentController());

    return Scaffold(
      appBar: AppBar(title: const Text('Student Management', style: TextStyle(color: TColors.primary)), centerTitle: true),
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
                      studentController.searchStudents(query);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Students',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      suffixIcon: IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                IconButton(
                  icon: const Icon(Iconsax.refresh, color: Colors.white),
                  onPressed: ()=>studentController.fetchDepartments(),
                ),
              ],
            ),

            // Display Departments or Search Results
            Expanded(
              child: Obx(() {
                if (studentController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show search results if there's a search query
                if (studentController.searchQuery.isNotEmpty) {
                  if (studentController.students.isEmpty) {
                    return const Center(child: Text('No students found.'));
                  }

                  // Display student search results as a list of cards
                  return ListView.builder(
                    itemCount: studentController.students.length,
                    itemBuilder: (context, index) {
                      final student = studentController.students[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile (
                          title: Text('${student['firstName']} ${student['lastName']}',
                              style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text('ID: ${student['id']}\nDepartment: ${student['department_code']}',
                              style: Theme.of(context).textTheme.titleMedium),
                          trailing: const Icon(Iconsax.profile),
                          onTap: () {
                            studentController.fetchStudentDetails(student['id']).then((details) {
                              _showStudentDetailsDialog(context, details);
                            });
                          },
                        ),
                      );
                    },
                  );
                }

                if (studentController.departments.isEmpty) {
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
                    itemCount: studentController.departments.length,
                    itemBuilder: (context, index) {
                      final department = studentController.departments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: TSizes.sm),
                        child: ListTile(
                          title: Text(department['department_name'], style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text('Students: ${department['student_count']}', style: Theme.of(context).textTheme.titleMedium),
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
          _showNewStudentDialog(context, studentController);
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showStudentDetailsDialog(BuildContext context, Map<String, dynamic> details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "${details['name']}",
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
                details['courses'].isNotEmpty
                    ? Text(details['courses'].join('\n'), style: const TextStyle(fontSize: 14.0))
                    : const Text("None", style: TextStyle(fontSize: 14.0)),
                
                const SizedBox(height: TSizes.sm),
                const Text(
                  "Unpaid Fees:",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                ),
                details['unpaidFees'] != null && details['unpaidFees'].isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: details['unpaidFees'].map<Widget>((fee) {
                          return Text(
                            "${fee['fee_type']}",
                            style: const TextStyle(fontSize: 14.0),
                          );
                        }).toList(),
                      )
                    : const Text("None", style: TextStyle(fontSize: 14.0)),
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
                const SizedBox(height: TSizes.sm),
                Row(
                  children: [
                    const Text(
                      "Hostel Room: ",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                    ),
                    (details['hostelRoom'] == null || details['hostelRoom']['allocation_status'] == 'not allocated')
                        ? const Text("Not a Hosteller", style: TextStyle(fontSize: 14.0))
                        : Text("${details['hostelRoom']['room_number']}", style: const TextStyle(fontSize: 14.0)),
                  ],
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

  void _showNewStudentDialog(BuildContext context, AdminStudentController studentController) {
    final idController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final departmentCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Admission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: idController, decoration: const InputDecoration(labelText: "ID")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
              const SizedBox(height: TSizes.sm),
              TextField(controller: departmentCodeController, decoration: const InputDecoration(labelText: "Department Code")),
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
                studentController.addStudent(
                  int.parse(idController.text),
                  firstNameController.text,
                  lastNameController.text,
                  departmentCodeController.text,
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

class AdminStudentController extends GetxController {
  var departments = <Map<String, dynamic>>[].obs;
  var students = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }

  // Fetch department data
  Future<void> fetchDepartments() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/departments-with-students'));
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

  // Search students in departments
  Future<void> searchStudents(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      students.clear();
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/search-students?query=$query'));
      if (response.statusCode == 200) {
        List<dynamic> studentData = json.decode(response.body);
        students.assignAll(studentData.map((e) => e as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load student data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addStudent(int id, String firstName, String lastName, String departmentCode) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/admission/new'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "firstName": firstName,
          "lastName": lastName,
          "department_code": departmentCode,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Student added successfully");
        fetchDepartments();
      } else {
        Get.snackbar("Error", "Failed to add student");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server");
    }
  }

  Future<Map<String, dynamic>> fetchStudentDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/student-details/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        Get.snackbar("Error", "Failed to load student details");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server");
    }
    return {};
  }
}