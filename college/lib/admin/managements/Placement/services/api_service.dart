import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; // Change this if the backend runs on a different host

  static Future<List<dynamic>> getCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companies'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load companies');
    }
  }
}
