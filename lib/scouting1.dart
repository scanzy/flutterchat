// first test (ChatGPT)

import 'package:flutter/material.dart';


class ChatPageTest1 extends StatelessWidget {
  const ChatPageTest1({super.key});

  final String chatName = "Chat room";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatName),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          _buildMessage("Ciao!", true),
          _buildMessage("Ciao! Come stai?", false),
          _buildMessage("Tutto bene, grazie!", true),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(text),
      ),
    );
  }
}
