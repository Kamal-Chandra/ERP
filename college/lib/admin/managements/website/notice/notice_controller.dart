import 'notice.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NoticeController extends GetxController{
  var isLoading = false.obs;
  var notices = <Notice>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
  }

  Future<bool> addNotice({
    required String title,
    required String noticeText,
    required String type,
    required String priority,
    String? attachmentUrl,
  }) async {
    if (title.isEmpty || noticeText.isEmpty) {
      Get.snackbar('Error', 'Title and notice text cannot be empty');
      return false;
    }

    final url = Uri.parse('http://localhost:3000/add-notice');

    try {
      isLoading.value = true;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'text': noticeText,
          'type': type,
          'priority': priority,
          'attachment': attachmentUrl,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Notice saved successfully');
        fetchNotices();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to save notice');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving the notice');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNotices() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/notices'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        notices.value = jsonData.map((json) => Notice.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      throw Exception('Failed to load notices');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteNotice(int noticeId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/delete-notice/$noticeId'));
      if (response.statusCode == 200) {
        await fetchNotices();
        return true;
      } else {
        throw Exception('Failed to delete notice');
      }
    } catch (e) {
      return false;
    }
  }
}