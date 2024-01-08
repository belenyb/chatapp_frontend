import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.0.2:4000/api'
      : 'http://localhost:4000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.0.2:4000'
      : 'http://localhost:4000';
}
