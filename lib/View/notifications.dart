import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Service/token.dart';

class notification extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<notification> {
  List<dynamic> notifications = [];
  String u = Global.user;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await http.get(Uri.parse('https://localhost:7218/api/Notification/userNotif/$u'));

    if (response.statusCode == 200) {
      setState(() {
        notifications = json.decode(response.body).reversed.toList(); // Inverser l'ordre des notifications
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> deleteNotification(int id) async {
    final response = await http.delete(
      Uri.parse('https://localhost:7218/api/Notification/$id'),
      headers: {
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        notifications.removeWhere((notification) => notification['id'] == id);
      });
    } else {
      throw Exception('Failed to delete notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.notifications_none_rounded), // Icône à gauche
              title: Text(notifications[index]['libelle']),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteNotification(notifications[index]['notif_ID']);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
