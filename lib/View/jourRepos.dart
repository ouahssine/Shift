import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Service/token.dart';

class jourRepos extends StatefulWidget {
  @override
  _JourReposState createState() => _JourReposState();
}

class _JourReposState extends State<jourRepos> {
  String selectedDay = 'Samedi';
  String e=Global.emp;
  int s=0;

  List<String> daysOfWeek = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];

  Future<void> envoyerDemande() async {
    switch (selectedDay) {
      case 'Lundi':
        s=1;
        break;
      case 'Mardi':
        s=2;
        break;
      case 'Mercredi':
        s=3;
        break;
      case 'Jeudi':
        s=4;
        break;
      case 'Vendredi':
        s=5;
        break;
      case 'Samedi':
        s=6;
        break;
      case 'Dimanche':
        s=7;
        break;
    }
    final String apiUrl = 'https://localhost:7218/api/DemandeDayOff/envoyerDemande';


    Map<String, dynamic> requestBody = {
      "utilisateurId": e,
      "jourProposee": s
    };
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type':'application/json;charset=UTF-8'} ,
        body: jsonEncode(requestBody));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Demande envoyée'),
            content: Text('Votre demande de jour de repos a été envoyée avec succès.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Échec de l\'envoi de la demande de jour de repos.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Demande de jour de repos",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFB8CBD0),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, size: 28),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFB8CBD0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sélectionnez :',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedDay,
                    dropdownColor:
                    Color(0xFFFFA07A),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue!;
                      });
                    },
                    items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Container(
                                height: 24,
                                width: 1,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  envoyerDemande();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF344D59)),
                ),
                child: Text('Envoyer la demande'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
