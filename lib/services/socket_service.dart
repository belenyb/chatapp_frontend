import 'package:chat_app/global/environment.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() {
    // Dart client
    // _socket = IO.io(Environment.socketUrl, {
    //   'transports': ['websocket'],
    //   'autoConnect': true,
    //   'forceNew': true
    // });

    _socket = IO.io(Environment.socketUrl,
        OptionBuilder().setTransports(['websocket']).enableForceNew().build());

    _socket.on('connect', (data) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (data) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
