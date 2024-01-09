import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../models/user.dart';

class AuthService with ChangeNotifier {
  final String apiBaseUrl = Environment.apiUrl;
  User? user;

  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

  //Create storage to manage token
  final _storage = const FlutterSecureStorage();

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<Map> login(String email, String password) async {
    isAuthenticating = true;

    final Map<String, String> data = {"email": email, "password": password};
    final Uri uri = Uri.parse('$apiBaseUrl/auth/login');

    try {
      final Response resp = await http.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (resp.statusCode == 200) {
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        user = loginResponse.user;
        await _saveToken(loginResponse.token);

        isAuthenticating = false;
        return {'login': true, 'message': 'ok'};
      } else {
        isAuthenticating = false;
        return {'login': false, 'message': resp.body};
      }
    } catch (e) {
      debugPrint(e.toString());
      isAuthenticating = false;
      return {'login': false, 'message': e.toString()};
    }
  }

  Future isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? "";
    final Uri uri = Uri.parse('$apiBaseUrl/auth/renew');

    try {
      final Response resp = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'x-token': token},
      );

      if (resp.statusCode == 200) {
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        user = loginResponse.user;
        await _saveToken(loginResponse.token);

        return true;
      } else {
        logout();
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future signup(String name, String email, String password) async {
    isAuthenticating = true;

    final Map<String, String> data = {
      "name": name,
      "email": email,
      "password": password
    };
    final Uri uri = Uri.parse('$apiBaseUrl/auth/signup');

    try {
      final Response resp = await http.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (resp.statusCode == 200) {
        final LoginResponse loginResponse = loginResponseFromJson(resp.body);
        user = loginResponse.user;
        await _saveToken(loginResponse.token);

        isAuthenticating = false;
        return jsonDecode(resp.body);
      } else {
        isAuthenticating = false;
        return jsonDecode(resp.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      isAuthenticating = false;
      return {'signup': false, 'msg': e.toString()};
    }
  }
}
