import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

import '../main.dart';
class msgRService {
  static final msgRService _instance = msgRService._internal();
  factory msgRService() => _instance;

  late HubConnection _hubConnection;
  late StreamController<String> _notificationController;
  late StreamController<String> _messageController;

  msgRService._internal() {
    _hubConnection = HubConnectionBuilder().withUrl("https://localhost:7218/chat").build();
    _notificationController = StreamController<String>();
    _messageController = StreamController<String>();

    _initSignalR();
  }

  Stream<String> get notificationStream => _notificationController.stream;
  Stream<String> get messageStream => _messageController.stream;

  Future<void> _initSignalR() async {
    try {
      await _hubConnection.start();
      print("connected");
      _hubConnection.on("ReceiveNotif", _handleNotification);
      _hubConnection.on("ReceiveMessage", _handleMessage);
    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  void _handleNotification(List<dynamic>? message) {
    if (message != null && message.isNotEmpty) {
      _notificationController.add(message[0]);
      print(message[0]);
      _showNotificationAlert(message[0]);
    }
  }

  void _handleMessage(List<dynamic>? message) {
    if (message != null && message.length >= 3) {
      _messageController.add(message[0]);
    }
  }

  void _showNotificationAlert(String message) {
    showDialog(
      context: NavigatorKey.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Naviguer vers la page des notifications
                Navigator.pushNamed(context, '/notifications');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    _hubConnection.stop();
    _notificationController.close();
    _messageController.close();
  }
}
