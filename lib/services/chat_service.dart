import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ChatService with ChangeNotifier {
  late User userTo;

  Future<List<Message>> getChat(String userToId) async {
    try {
      final token = await AuthService.getToken();
      final Uri uri = Uri.parse('${Environment.apiUrl}/messages/$userToId');
      final resp = await http.get(uri,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final messagesResp = messagesResponseFromJson(resp.body);
      return messagesResp.messages;
    } catch (e) {
      debugPrint('Error in ChatService: ${e.toString()}');
      return [];
    }
  }
}
