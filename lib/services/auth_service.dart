import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthService(this._dio);

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final token = response.data['tokenJWT']; // Ensure this matches your API response
        if (token != null) {
          await _storage.write(key: 'jwt', value: token);
          await _storage.write(key: 'userId', value: response.data['user']['id']);
          return true;
        }
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }


  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload =
    utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }
}