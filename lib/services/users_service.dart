import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/userslist_response.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final Uri uri = Uri.parse('${Environment.apiUrl}/users');
      final token = await AuthService.getToken();
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      });

      final UsersListResponse usersResponse = usersListFromJson(resp.body);

      return usersResponse.users;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
