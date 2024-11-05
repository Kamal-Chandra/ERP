import 'image.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  var isLoading = false.obs;
  var images = <ERPImage>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<bool> addImage(String url) async {
    if (url.isEmpty) {
      Get.snackbar('Error', 'URL cannot be empty');
      return false;
    }

    final imageUrl = Uri.parse('http://localhost:3000/add-image');

    try {
      isLoading.value = true;
      final response = await http.post(
        imageUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Image added successfully');
        fetchImages();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add image: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding the image');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchImages() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/images'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        images.value = jsonData.map((json) => ERPImage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load images: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load images');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteImage(int imageId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/delete-image/$imageId'));
      if (response.statusCode == 200) {
        fetchImages();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete image: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the image');
      return false;
    }
  }
}
