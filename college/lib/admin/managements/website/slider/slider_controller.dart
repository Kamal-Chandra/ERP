import 'slider.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SliderController extends GetxController {
  var isLoading = false.obs;
  var sliders = <Slider>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
  }

  Future<bool> addSlider({
    required String title,
    required String description,
    required Uint8List imageData,
  }) async {
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar('Error', 'Title and description cannot be empty');
      return false;
    }
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('http://localhost:3000/sliders'), // Ensure this is the correct URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title, // No need for utf8.encode here as jsonEncode handles it
          'description': description,
          'imageData': base64Encode(imageData) // Image data as Base64
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Slider saved successfully');
        fetchSliders(); // Fetch updated list of sliders
        return true;
      } else {
        Get.snackbar('Error', 'Failed to save slider: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving the slider: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSliders() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/sliders'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        sliders.value = data.map((item) => Slider(
          sliderId: item['slider_id'],
          imageData: base64Decode(item['image_data']), // Decode Base64 image data
          title: item['title'], // Assuming title is received in a proper format
          description: item['description'], // Assuming description is received in a proper format
          datePosted: DateTime.parse(item['date_posted']), // Ensure the date format is correct
        )).toList();
      } else {
        Get.snackbar('Error', 'Failed to load sliders: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sliders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSlider(int sliderId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/sliders/$sliderId'),
      );

      if (response.statusCode == 200) {
        fetchSliders();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete slider: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the slider: $e');
      return false;
    }
  }
}