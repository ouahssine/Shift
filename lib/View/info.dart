import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shift/Service/token.dart';

class info extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<info> {
  // Déclaration des variables pour stocker les informations de l'utilisateur
  String userName = '';
  String email = '';
  String phoneNumber = '';

  // Fonction pour récupérer les données de l'API
  Future<void> fetchUserInfo() async {
    final String u = Global.user;
    final response = await http.get(Uri.parse('https://localhost:7218/api/Utilisateur/$u'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final employe = jsonData['employe'];

      setState(() {
        userName = employe['nomComplet'] as String;
        phoneNumber = employe['numeroTel'] as String;
        email = jsonData['email'];
      });
    } else {
      print('eeeeeeee');
      throw Exception('Failed to load user information');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: <Widget>[
                Icon(Icons.person, size: 125, color: Colors.grey), // Grande icône à gauche
                SizedBox(width: 16), // Espacement entre l'icône et le texte
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nom et Prénom:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userName,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildCardWithIcon(Icons.phone, 'Téléphone', userName),
          buildCardWithIcon(Icons.email, 'Email', email),
        ],
      ),
    );
  }

  Widget buildCardWithIcon(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: Icon(icon), // Icone à gauche du ListTile
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

