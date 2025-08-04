import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Service/token.dart';
import 'mesage.dart';

class recherche extends StatefulWidget {
  @override
  rechercheState createState() => rechercheState();
}

class rechercheState extends State<recherche> {
  List<dynamic> conversations = [];
  List<dynamic> users = [];
  String token = Global.t;
  String etablissementID=Global.etb;
  String s = Global.user;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchConversations();
    fetchUsers(); // Appel pour charger tous les utilisateurs
  }

  Future<void> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://localhost:7218/api/Utilisateur/byEtabId/$etablissementID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        users = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
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

  Future<void> searchUsers(String query) async {
    final response = await http.get(
      Uri.parse('https://localhost:7218/api/Utilisateur/byEtabId/$etablissementID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> allUsers = jsonDecode(response.body);
        users = allUsers.where((user) => user['userName'].toLowerCase().contains(query.toLowerCase())).toList();
      });
    } else {
      throw Exception('Failed to load users');
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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  searchUsers(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search Users',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchUsers(searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_circle), // Icon utilisateur
                        SizedBox(width: 10), // Espacement entre l'icône et le texte
                        Text(users[index]['userName']),
                      ],
                    ),
                  ),
                  onTap: () {
                    createConversation(users[index]['userId']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
