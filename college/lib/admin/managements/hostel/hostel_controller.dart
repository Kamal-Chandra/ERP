import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HostelController extends GetxController {
  var students = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var totalCount = 0.obs;
  var hostellersCount = 0.obs;
  var dayScholarsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHostelStatistics();
    fetchStudents();
  }

  Future<void> fetchHostelStatistics() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/hostel-stats'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        totalCount.value = data['total_students'] ?? 0;
        hostellersCount.value = data['hostellers'] ?? 0;
        dayScholarsCount.value = data['day_scholars'] ?? 0;
      } else {
        Get.snackbar('Error', 'Failed to load statistics');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  Future<void> fetchStudents() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/students-with-hostel-info'));
      if (response.statusCode == 200) {
        final studentData = json.decode(response.body) as List<dynamic>;
        students.assignAll(studentData.map((e) => e as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load students');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchStudents(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchStudents();
      return;
    }
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/search-hostel-students?query=$query'));
      if (response.statusCode == 200) {
        final studentData = json.decode(response.body) as List<dynamic>;
        students.assignAll(studentData.map((e) => e as Map<String, dynamic>).toList());
      } else {
        Get.snackbar('Error', 'Failed to load student data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  Future<void> allocateRoom(int studentId, String roomNumber) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/allocate-room'),
        body: json.encode({'student_id': studentId, 'allocation_status': 'allocated', 'room_number': roomNumber}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        fetchStudents();
        fetchHostelStatistics();
        Get.snackbar('Success', 'Room allocated successfully');
      } else {
        Get.snackbar('Error', 'Failed to allocate room');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  Future<void> deallocateRoom(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/allocate-room'),
        body: json.encode({'student_id': studentId, 'allocation_status': 'not allocated', 'room_number': null}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        fetchStudents();
        fetchHostelStatistics();
        Get.snackbar('Success', 'Room deallocated successfully');
      } else {
        Get.snackbar('Error', 'Failed to deallocate room');
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred while deallocating room: $error');
    }
  }
}