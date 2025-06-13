import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api',
    headers: {'Accept': 'application/json'},
  ));

  /// Returns a map with 'token' and 'userId' on success, or null on failure.
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'username': username,
        'password': password,
      });

      final token = response.data['token'] as String;
      final userId = response.data['user']['id'] as int;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('userId', userId);

      return {'token': token, 'userId': userId};
    } on DioException catch (e) {
      print('Login failed: ${e.response?.data}');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      await _dio.post('/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await prefs.remove('token');
      await prefs.remove('userId');
    }
  }

  /// Fetches token + userId from SharedPreferences
  Future<Map<String, dynamic>?> getAuthInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    if (token != null && userId != null) {
      return {'token': token, 'userId': userId};
    }
    return null;
  }
}
