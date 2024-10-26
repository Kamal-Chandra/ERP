import 'package:dio/dio.dart';

class Api {
  static final Dio _dio = Dio();

  static Future<Response> loginStudent(String username, String password) {
    return _dio.post(
      'http://localhost:3000/login/student',
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  static Future<Response> loginInstructor(String username, String password) {
    return _dio.post(
      'http://localhost:3000/login/instructor',
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  static Future<Response> loginAdmin(String username, String password) {
    return _dio.post(
      'http://localhost:3000/login/admin',
      data: {
        'username': username,
        'password': password,
      },
    );
  }
}