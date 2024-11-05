import 'slider.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SliderController extends GetxController {
  var isLoading = false.obs;
  var sliders = <Slider>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
  }

  Future<bool> addSlider(String title, String url) async {
    if (title.isEmpty || url.isEmpty) {
      Get.snackbar('Error', 'Title and URL cannot be empty');
      return false;
    }

    final sliderUrl = Uri.parse('http://localhost:3000/add-slider');

    try {
      isLoading.value = true;
      final response = await http.post(
        sliderUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'url': url}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Slider added successfully');
        fetchSliders();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add slider: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding the slider');
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
        final List<dynamic> jsonData = json.decode(response.body);
        sliders.value = jsonData.map((json) => Slider.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sliders: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sliders');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSlider(int sliderId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/delete-slider/$sliderId'));
      if (response.statusCode == 200) {
        fetchSliders();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to delete slider: ${response.body}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the slider');
      return false;
    }
  }
}
