import 'package:flutter/material.dart';
class task extends StatelessWidget {
  final List<dynamic>? tasks;

  task({Key? key, this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Taches",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: tasks != null
          ? ListView.builder(
        itemCount: tasks!.length,
        itemBuilder: (context, index) {
          return TaskItem(
            title: tasks![index]['tache']['libelle'],
            note: tasks![index]['note'] != null
                ? tasks![index]['note']
                : 'Aucune note disponible',
          );
        },
      )
          : Center(
        child: Text("Aucune tâche disponible"),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String title;
  final String note;

  TaskItem({Key? key, required this.title, required this.note})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(note),
      ),
    );
  }
}