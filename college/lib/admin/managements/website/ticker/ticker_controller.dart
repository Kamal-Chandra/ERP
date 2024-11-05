import 'ticker.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TickerController extends GetxController {
  var isLoading = false.obs;
  var tickers = <Ticker>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickers();
  }

  Future<bool> addTicker({
    required String message,
  }) async {
    if (message.isEmpty) {
      Get.snackbar('Error', 'Ticker message cannot be empty');
      return false;
    }

    final url = Uri.parse('http://localhost:3000/add-ticker');

    try {
      isLoading.value = true;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Ticker saved successfully');
        await fetchTickers();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to save ticker');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving the ticker');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTickers() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/tickers'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        tickers.value = jsonData.map((json) => Ticker.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tickers');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tickers');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteTicker(int tickerId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/delete-ticker/$tickerId'));
      if (response.statusCode == 200) {
        await fetchTickers();
        return true;
      } else {
        throw Exception('Failed to delete ticker');
      }
    } catch (e) {
      return false;
    }
  }
}
