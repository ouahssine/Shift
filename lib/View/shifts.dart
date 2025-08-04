import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shift/View/jourRepos.dart';
import 'task.dart'; // Correction ici

import '../Service/token.dart';

class shift extends StatefulWidget { // Renommage de la classe pour respecter la convention de nommage
  @override
  _ShiftState createState() => _ShiftState();
}

class _ShiftState extends State<shift> {
  List<Map<String, dynamic>> shiftData = [];
  final String apiUrl = 'https://localhost:7218/api/Jour/ByDate/';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DateTime startOfWeek = DateTime.now();
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    String e = Global.etb;
    String employeID = Global.emp;

    shiftData = [];

    for (DateTime date = startOfWeek; date.isBefore(endOfWeek); date = date.add(Duration(days: 1))) {
      String dateFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date);
      String apiUrlWithDate = '$apiUrl$dateFormatted/$e';
      var response = await http.get(Uri.parse(apiUrlWithDate));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        bool isWorking = false;
        String shiftType = "Nuit";

        for (var shift in jsonData['shifts']) {
          for (var emp in shift['employes']) {
            if (emp['empId'].toString() == employeID) {
              isWorking = true;
              DateTime heureDebut = DateTime.parse(shift['heureDebut']);
              if (heureDebut.hour < 15) {
                shiftType = "Jour";
              }
              break;
            }
          }
        }

        setState(() {
          shiftData.add({
            'date': jsonData['date'],
            'isWorking': isWorking,
            'shiftType': shiftType,
            'tasks': jsonData['shifts'][0]['employes'][0]['taches'], // Correction ici
          });
        });
      } else {
        throw Exception('Failed to load data for $dateFormatted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: shiftData.length,
        itemBuilder: (context, index) {
          final shiftItem = shiftData[index];
          Color day = Color(0xFF344D59);
          if (shiftItem['shiftType'] == "Jour") {
            day = Color(0xFF137C8B);
          }
          return Container(
            color: Color(0xFFB8CBD0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFB8CBD0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        DateFormat('E').format(DateTime.parse(shiftItem['date'])).substring(0, 3),
                        style: TextStyle(
                          color: Color(0xFF344D59),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(shiftItem['date']),
                  ],
                ),
                trailing: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: day,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    shiftItem['isWorking'] ? "Shift ${shiftItem['shiftType']}" : "Non travaillé",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => task(tasks: shiftItem['tasks']), // Correction ici
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/calendrier');
            },
            backgroundColor: Color(0xFF7A90A4),
            child: Icon(Icons.repeat),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Color(0xFFB8CBD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      width: 400,
                      height: 200,
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: jourRepos(),
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: Color(0xFF679436),
            child: Icon(Icons.event_busy),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
