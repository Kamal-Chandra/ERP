import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FeeController extends GetxController {
  var students = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var paidCount = 0.obs;
  var unpaidCount = 0.obs;
  var totalCount = 0.obs;
  var unpaidFees = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
    fetchFeeStatistics();
  }

  Future<void> fetchFeeStatistics() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/students-fee-counts'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        paidCount.value = int.tryParse(data['paid_count']) ?? 0;
        unpaidCount.value = int.tryParse(data['unpaid_count']) ?? 0;
        totalCount.value = (paidCount.value + unpaidCount.value);
      } else {
        Get.snackbar('Error', 'Failed to load fee statistics.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server.');
    }
  }

  Future<void> fetchStudents() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/students-with-fees/'));
      if (response.statusCode == 200) {
        final studentData = json.decode(response.body) as List<dynamic>;
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

  Future<void> searchStudents(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchStudents();
      return;
    }
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/search-students-fee?query=$query'));
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

  Future<void> introduceFee(String feeType, double amount, String dueDate) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/introduce-fee'),
        body: json.encode({'fee_type': feeType, 'amount': amount, 'due_date': dueDate}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Fee introduced successfully for all students.');
        fetchFeeStatistics();
        fetchStudents();
      } else {
        Get.snackbar('Error', 'Failed to introduce fee.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server.');
    }
  }

  Future<void> fetchUnpaidFees(int studentId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/unpaid-fees/$studentId'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is List) {
        unpaidFees.value = data.map((fee) => fee['fee_type'] as String).toList();
      } else {
        Get.snackbar('Error', 'Unexpected response format');
      }
    } else {
      Get.snackbar('Error', 'Failed to load unpaid fees');
    }
  }

  Future<void> updateFeeStatus(int studentId, String transactionId, String feeType) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/update-fee-status'),
        body: json.encode({'student_id': studentId, 'transaction_id': transactionId, 'fee_type': feeType}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        fetchFeeStatistics();
        fetchStudents();
        Get.snackbar('Success', 'Fee status updated to paid.');
      } else {
        Get.snackbar('Error', 'Failed to update fee status.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server.');
    }
  }
}