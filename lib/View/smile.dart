import 'package:flutter/material.dart';

class smile extends StatefulWidget {
  @override
  smileState createState() => smileState();
}

class smileState extends State<smile> {
  String _selectedEmoji = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Comment allez-vous aujourd'hui ?",style: TextStyle(color: Colors.black),),
        backgroundColor:Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close,size:28),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Comment allez-vous aujourd\'hui ?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = '😞';
                        Navigator.pop(context);
                      });
                    },
                    icon: Text('😞', style: TextStyle(fontSize: 27)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = '😐';
                        Navigator.pop(context);
                      });
                    },
                    icon: Text('😐', style: TextStyle(fontSize: 27)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = '😊';
                        Navigator.pop(context);
                      });
                    },
                    icon: Text('😊', style: TextStyle(fontSize: 27)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = '😄';
                        Navigator.pop(context);
                      });
                    },
                    icon: Text('😄', style: TextStyle(fontSize: 27)),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
