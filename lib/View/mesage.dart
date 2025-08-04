import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Service/token.dart';

class Messages extends StatefulWidget {
  final int conversationId;

  Messages(this.conversationId);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<Messages> {
  late HubConnection _hubConnection;
  String token = Global.t;
  TextEditingController messageController = TextEditingController();
  List<dynamic> messages = [];
  int messageOffset = 0;

  @override
  void initState() {
    super.initState();
    _hubConnection = HubConnectionBuilder()
        .withUrl(
      'https://localhost:7218/chat',
      HttpConnectionOptions(
        accessTokenFactory: () async => token,
      ),
    )
        .build();

    _hubConnection.on('ReceiveMessage', _handleNewMessage);
    _startConnection();
    fetchMessages();
  }

  Future<void> _startConnection() async {
    try {
      await _hubConnection.start();
      print('Connected to SignalR Hub');
      await _hubConnection.invoke('JoinRoom', args: [widget.conversationId.toString()]);
      print('Joined room: ${widget.conversationId}');
    } catch (e) {
      print('Error while establishing connection to SignalR Hub: $e');
    }
  }

  void _handleNewMessage(List<dynamic>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      String messageContent = arguments[0] as String;
      String senderId = arguments[1] as String; // Assuming sender ID is sent as the second argument
      String timestamp = arguments[2] as String;

      setState(() {
        print(messageContent);
        messages.insert(messageOffset, {"idEnvoyeur": senderId, "contenu": messageContent, "horodatage": timestamp});
        messageOffset++;
      });
    }
  }

  Future<void> sendMessage(String messageContent) async {
    String senderId = Global.user.toString();
    String timestamp = DateTime.now().toIso8601String();
    setState(() {
      messages.insert(0, {"idEnvoyeur": senderId, "contenu": messageContent, "horodatage": timestamp});
    });

    try {
      await _hubConnection.invoke(
        'SendMessage',
        args: [widget.conversationId.toString(), messageContent, senderId],
      );
      messageController.clear();
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  Future<void> fetchMessages() async {
    final response = await http.get(
      Uri.parse(
          'https://localhost:7218/api/Conversations/getMessages/${widget.conversationId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        messages = jsonDecode(response.body).reversed.toList();
        messageOffset = messages.length; // Resetting message offset
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                bool isSentByUser = message['idEnvoyeur'].toString() == Global.user.toString();

                return Align(
                  alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSentByUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      message['contenu'],
                      style: TextStyle(
                        color: isSentByUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Ecrire votre message...',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendMessage(messageController.text);
                    }
                  },
                  child: Icon(Icons.send_sharp, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Background color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
