import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:shift/View/index.dart';
import 'package:shift/View/login.dart';
import 'package:shift/View/chat.dart';
import 'package:shift/View/task.dart';
import 'package:shift/View/notifications.dart';
import 'package:shift/View/info.dart';
import 'package:shift/View/jourRepos.dart';
import 'package:shift/View/shifts.dart';
import 'package:shift/View/calendrier.dart';
import 'package:shift/View/smile.dart';
import 'package:shift/View/demandEchange.dart';
import 'package:shift/View/recherche.dart';

import 'Service/notification.dart';

class NavigatorKey {
  static final navigatorKey = GlobalKey<NavigatorState>();
}
/*
class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;

  late HubConnection _hubConnection;
  late StreamController<String> _notificationController;

  SignalRService._internal() {
    _hubConnection = HubConnectionBuilder().withUrl("https://localhost:7218/notif").build();
    _notificationController = StreamController<String>();

    _initSignalR();
    onConnectedR();
  }

  Future<void> onConnectedR() async {
    try {
      _hubConnection.on("OnConnected", (arguments) {
        addUserConnection('12');
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
  }
}*/
void main() {
 /* final signalRService = SignalRService();
  signalRService.notificationStream.listen((notification) {
    print("Received notification: $notification");
  });*/

  runApp(MaterialApp(
    navigatorKey: NavigatorKey.navigatorKey,

    debugShowCheckedModeBanner: false,
    initialRoute: '/index',
    routes: {
      '/login': (context) => LoginScreen(),
      '/index': (context) => index(),
      '/shift': (context) => shift(),
      '/chat': (context) => chat(),
      '/notifications': (context) => notification(), // Utilisation de NotificationScreen ici
      '/info': (context) => info(),
      '/jourRepos': (context) => jourRepos(),
      '/calendrier': (context) => calendrier(),
      '/smile': (context) => smile(),
      '/DemandeEchange': (context) => DemandeEchange(),
      '/recherche': (context) => recherche(),
    },
  ));
}
