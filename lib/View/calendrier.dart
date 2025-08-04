import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import du package http
import 'package:table_calendar/table_calendar.dart';
import '../Service/token.dart';
import 'demandEchange.dart';
import 'echange.dart'; // Importer le fichier echange.dart contenant l'interface echange

class calendrier extends StatefulWidget {
  @override
  _CalendrierState createState() => _CalendrierState();
}

class _CalendrierState extends State<calendrier> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().add(Duration(days: 7)); // Ajouter une semaine
  DateTime? _selectedDay;
  String d=Global.dayoff;

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://localhost:7218/api/DemandeEchange/getDemandesForUtilisateurCible/12'));

    if (response.statusCode == 200) {
      // Traiter la réponse ici
      print(jsonDecode(response.body));
    } else {
      // Gérer les erreurs ici
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Changement de shift",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        )
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            enabledDayPredicate: (day) {
              // Désactiver chaque dimanche (jour de la semaine 7)
              return day.weekday != int.parse(d);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // Naviguer vers l'interface echange avec la date sélectionnée
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => echange(selectedDay)),
              );
            },
          ),
          // Ajouter un espace entre le calendrier et le bouton
          SizedBox(height: 20),
          // Bouton pour récupérer les données de l'API
          ElevatedButton(
            onPressed:() {Navigator.pushReplacementNamed(context, '/DemandeEchange');},
            child: Text('Afficher Les Demandes'),
          ),
        ],
      ),
    );
  }
}
