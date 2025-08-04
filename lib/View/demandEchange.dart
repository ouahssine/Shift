import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DemandeEchange extends StatefulWidget {
  @override
  _DemandeEchangeDetailsState createState() => _DemandeEchangeDetailsState();
}

class _DemandeEchangeDetailsState extends State<DemandeEchange> {
  List<dynamic> data = [];

  // Méthode pour afficher le pop-up
  void _showDialog(int idDemande) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmer l'action"),
          content: Text("Voulez-vous approuver ou refuser cette demande ?"),
          actions: <Widget>[
            TextButton(
              child: Text("Approuver"),
              onPressed: () {
                _approuverDemande(idDemande);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Refuser"),
              onPressed: () {
                _refuserDemande(idDemande);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDemande();
  }

  Future<void> fetchDemande() async {
    final response = await http.get(Uri.parse('https://localhost:7218/api/DemandeEchange/getDemandesForUtilisateurCible/11'));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body).reversed.toList(); // Inverser l'ordre des notifications
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Méthode pour approuver la demande
  Future<void> _approuverDemande(int idDemande) async {
    final response = await http.post(Uri.parse('https://localhost:7218/api/DemandeEchange/accepterDemandeParCible/$idDemande'));

    if (response.statusCode == 200) {
      // Demande approuvée, actualiser la liste des demandes
      fetchDemande();
    } else {
      throw Exception('Failed to approve request');
    }
  }

  // Méthode pour refuser la demande
  Future<void> _refuserDemande(int idDemande) async {
    final response = await http.post(Uri.parse('https://localhost:7218/api/DemandeEchange/refuserDemandeParCible/$idDemande'));

    if (response.statusCode == 200) {
      // Demande refusée, actualiser la liste des demandes
      fetchDemande();
    } else {
      throw Exception('Failed to reject request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Les demande de changement de Shift",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Demande de changement de Shift avec "+data[index]['iDempdemandeur'].toString()),
              onTap: () {
                _showDialog(data[index]['idDemande']); // Afficher le pop-up au clic
              },
            ),
          );
        },
      ),
    );
  }
}
