import 'video.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VideoController extends GetxController {
  var isLoading = false.obs;
  var videos = <Video>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  Future<bool> addVideo({
    required String title,
    required String url,
  }) async {
    if (title.isEmpty || url.isEmpty) {
      Get.snackbar('Error', 'Title and URL cannot be empty');
      return false;
    }

    final videoUrl = Uri.parse('http://localhost:3000/add-video');

    try {
      isLoading.value = true;
      final response = await http.post(
        videoUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'url': url,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Video saved successfully');
        fetchVideos();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to save video: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving the video');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVideos() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/videos'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        videos.value = jsonData.map((json) => Video.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load videos: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load videos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteVideo(int videoId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/delete-video/$videoId'));
      if (response.statusCode == 200) {
        fetchVideos();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete video: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the video');
      return false;
    }
  }
}