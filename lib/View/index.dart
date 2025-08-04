import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shift/View/shifts.dart';
import 'package:shift/View/chat.dart';
import 'package:shift/View/info.dart';
import 'package:badges/badges.dart' as badge;
import 'package:http/http.dart' as http; // Import the http package

import '../Service/notification.dart';
import '../Service/token.dart';

class index extends StatefulWidget {
  @override
  IndexScreenState createState() => IndexScreenState();
}

class IndexScreenState extends State<index> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  int notificationCount = 0; // Nombre de notifications non lues
  List<dynamic> notifications = []; // Store notifications
  final signalRService = SignalRService();

  @override
  void initState() {
    super.initState();
    fetchUnreadNotifications(); // Fetch unread notifications on init
    signalRService.notificationStream.listen((notification) {
      notificationCount++;
    });
  }

  // Function to fetch unread notifications
  Future<void> fetchUnreadNotifications() async {
    final response = await http.get(Uri.parse('https://localhost:7218/api/Notification/userNotif/'));

    if (response.statusCode == 200) {
      setState(() {
        notifications = jsonDecode(response.body);
        notificationCount = notifications.where((notification) => !notification['isRead']).length;
      });
    } else {
      // Handle error
      throw Exception('Failed to load notifications');
    }
  }

  // Function to mark a notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final response = await http.put(
      Uri.parse('https://localhost:7218/api/Notification/$notificationId'),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isRead': true}),
    );

    if (response.statusCode == 200) {
      await fetchUnreadNotifications(); // Refresh the notification count
    } else {
      // Handle error
      throw Exception('Failed to mark notification as read');
    }
  }

  void resetNotificationCount() {
    setState(() {
      notificationCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shift Master",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          badge.Badge(
            badgeContent: Text(
              notificationCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            position: badge.BadgePosition.topEnd(top: 7, end: 0),
            child: IconButton(
              icon: Icon(Icons.notifications, size: 28),
              color: Colors.black,
              onPressed: () async {
                for (var notification in notifications) {
                  if (!notification['isRead']) {
                    await markNotificationAsRead(notification['notif_ID']);
                  }
                }
                resetNotificationCount();
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, size: 28),
            color: Colors.black,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Se déconnecter",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Text(
                                "Oui",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF344D59)),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all<Size>(Size(200, 35)),
                              ),
                              onPressed: () {
                                Global.t = '';

                                Navigator.pushNamed(context, '/login');
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Text(
                                "Non",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF939597)),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all<Size>(Size(200, 35)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFF137C8B),
        color: Color(0xFF137C8B),
        animationDuration: const Duration(milliseconds: 306),
        items: const <Widget>[
          Icon(Icons.schedule, size: 26, color: Colors.white),
          Icon(Icons.message, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: <Widget>[
        shift(),
        chat(),
        info(),
      ][currentPageIndex],
    );
  }
}
