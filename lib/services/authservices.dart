import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api', // change to your backend IP/port
    headers: {
      'Accept': 'application/json',
    },
  ));

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'username': username,
        'password': password,
      });

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } on DioException catch (e) {
      print('Login failed: ${e.response?.data}');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await _dio.post('/logout',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      await prefs.remove('token');
    }
  }
}
