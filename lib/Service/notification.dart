import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shift/Service/token.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  String u = Global.user;

  late HubConnection _hubConnection;
  late StreamController<String> _notificationController;

  SignalRService._internal() {
    _hubConnection = HubConnectionBuilder().withUrl("https://localhost:7218/notif").build();
    _notificationController = StreamController<String>.broadcast();

    _initSignalR();
    onConnectedR();
  }

  Future<void> onConnectedR() async {
    try {
      _hubConnection.on("OnConnected", (arguments) {
        addUserConnection(u);
      });
    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  Future<void> addUserConnection(String userId) async {
    try {
      await _hubConnection.invoke("addUserConnection", args: [userId]);
    } catch (e) {
      print("Error invoking AddUserConnection: $e");
    }
  }

  Stream<String> get notificationStream => _notificationController.stream;

  Future<void> _initSignalR() async {
    try {
      await _hubConnection.start();
      _hubConnection.on("ReceiveNotif", _handleNotification);
    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  void _handleNotification(List<dynamic>? message) {
    if (message != null && message.isNotEmpty) {
      _notificationController.add(message[0]);
      _showNotificationAlert(message[0]);
      _initNotifications();
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

  void _initNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    // Configuration des paramètres d'initialisation des notifications locales
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('app_icon'), // Replace 'app_icon' with your icon name
    );

    // Initialisation de flutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? message) async {
          // Gérer le clic sur la notification
          // Ici, vous pouvez naviguer vers l'écran approprié ou effectuer toute autre action
          print('Notification : $message');
        });
  }

  void dispose() {
    _hubConnection.stop();
    _notificationController.close();
  }
}
