import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Future<bool> login(String email, String password) async {
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

        isAuthenticating = false;
        return true;

      } else {
        isAuthenticating = false;
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      isAuthenticating = false;
      return false;
    }
  }
}
