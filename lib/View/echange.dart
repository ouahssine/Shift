import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Service/token.dart'; // Assurez-vous que ce chemin est correct

class echange extends StatefulWidget {
  final DateTime? selectedDay;

  echange(this.selectedDay);

  @override
  _EchangeState createState() => _EchangeState();
}

class _EchangeState extends State<echange> {
  List<dynamic> shiftData = [
  ];
  String e = Global.etb; // Assurez-vous que Global est accessible et défini
  String u = Global.user; // Assurez-vous que Global est accessible et défini
  String em=Global.emp;

  @override
  void initState() {
    super.initState();
    fetchShiftData();
  }

  Future<void> fetchShiftData() async {
    final url = Uri.parse('https://localhost:7218/api/Jour/ByDate/${DateFormat('yyyy-MM-dd').format(widget.selectedDay!)}/$e');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        shiftData = responseData['shifts'];
      });
    } else {
      print('Failed to fetch shift data: ${response.reasonPhrase}');
    }
  }

  Future<void> sendExchangeRequest(int demandeurId, int utilisateurCibleId, DateTime dateProposee) async {

    final url = Uri.parse('https://localhost:7218/api/DemandeEchange/envoyerDemande');
    final response = await http.post(
      url,
      headers: {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "iDdemandeur": demandeurId,
        "idUtilisateurCible": utilisateurCibleId,
        "dateProposee": dateProposee.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      print('Demande d\'échange envoyée avec succès');
    } else {
      print('Erreur lors de l\'envoi de la demande d\'échange: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employés pour la date (${widget.selectedDay != null ? DateFormat('dd/MM/yyyy').format(widget.selectedDay!) : 'Date non sélectionnée'}) :",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: widget.selectedDay != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: shiftData.length,
                itemBuilder: (context, index) {
                  var shift = shiftData[index];
                  List<dynamic> employees = shift['employes'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: employees.where((employee) => employee["empId"] != 5).map((employee) {
                      List<dynamic>? taches = employee['taches'];
                      List<Widget> tachesWidgets = [];
                      if(taches != null) {
                        tachesWidgets = taches.map((tache) {
                          return Text(
                            "${tache['tache']['libelle']}",
                            style: TextStyle(fontSize: 16),
                          );
                        }).toList();
                      }
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmation"),
                                  content: Text("Voulez-vous confirmer le changement de shift avec ${employee["nomComplet"]} ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Annuler"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Confirmer"),
                                      onPressed: () {
                                        sendExchangeRequest(
                                          int.parse(em), // ID du demandeur (à remplacer par l'ID réel)
                                          employee["empId"], // ID de l'utilisateur cible (à remplacer par l'ID réel)
                                          widget.selectedDay!, // Date proposée
                                        );
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${employee["nomComplet"]}",
                                style: TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                              SizedBox(height: 5),
                              ...tachesWidgets,
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        )
            : Text("Aucune date sélectionnée"),
      ),
    );
  }
}
