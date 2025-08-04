import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Service/chat.dart';
import '../Service/token.dart';
import 'mesage.dart';

class chat extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}


class _ConversationsPageState extends State<chat> {
  List<dynamic> conversations = [
  ];
  String token=Global.t;
  String s=Global.user;
  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    final response = await http.get(
      Uri.parse('https://localhost:7218/api/Conversations/getConversations/$s'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        conversations = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load conversations');
    }
  }
  Future<void> createConversation(int userId) async {
    print(userId);
    print(s);
    final response = await http.get(Uri.parse('https://localhost:7218/api/Conversations/create?UserId1=$s&UserId2=$userId'));


    if (response.statusCode == 200) {
      // Parse the response body to extract the idConversation
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final int idConversation = responseData['idConversation'];
      print(idConversation);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Messages(idConversation)),
      );
    } else {
      throw Exception('Failed to create conversation');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversations",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/recherche');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (BuildContext context, int index) {
          var conversation = conversations[index];
          String userName = conversation['userName']; // Nom d'utilisateur
          int userId = conversation['userId'];

          return ListTile(
            title: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_circle), // Icon utilisateur
                  SizedBox(width: 10), // Espacement entre l'icône et le texte
                  Text(userName), // Afficher le nom d'utilisateur
                ],
              ),
            ),

            onTap: () {
              //createConversation(userId);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Messages(1)),
              );
            },
          );
        },
      ),
    );
  }

}
