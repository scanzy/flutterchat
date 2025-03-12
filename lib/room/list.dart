import 'package:flutter/material.dart';

import 'package:flutterchat/chat/screen.dart';
import 'package:flutterchat/utils/misc.dart';


class Room {
  final String name;
  final String type;
  final String lastMsgPreview;
  final DateTime lastCreated;
  final int unreadMessages;

  Room({
    required this.name,
    required this.type,
    required this.lastMsgPreview,
    required this.lastCreated,
    required this.unreadMessages,
  });
}


// rooms list
class RoomsListScreen extends StatelessWidget {
  RoomsListScreen({super.key});

  final List<Room> rooms = [
    Room(
      name: "Branco",
      type: "Generale",
      lastMsgPreview: "user: Ciao uomini!",
      lastCreated: DateTime.now(),
      unreadMessages: 10,
    ),
    Room(
      name: "Branco del Nord",
      type: "Locale",
      lastMsgPreview: "user nordico: Uee uomini!",
      lastCreated: DateTime.now(),
      unreadMessages: 12,
    ),
    Room(
      name: "Branco del Centro",
      type: "Locale",
      lastMsgPreview: "user centrale: daje uomini!",
      lastCreated: DateTime.now(),
      unreadMessages: 2,
    ),
    Room(
      name: "Branco del Sud",
      type: "Locale",
      lastMsgPreview: "user: Weeeeee! Jamme ja",
      lastCreated: DateTime.now(),
      unreadMessages: 8,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat app"),
      ),
      body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text('Here all the rooms'),
        ),
        Expanded(
          child: ListView.separated(
            // controller: _scrollController,
            itemCount: rooms.length,
            itemBuilder: (context, index) => _buildRoomRow(context, rooms[index]),
            separatorBuilder: (context, index) => Divider(thickness: 2),
          ),
        ),
      ]),
    );
  }


  Widget _buildRoomRow(BuildContext context, Room room) { 
    return ListTile(

      leading: CircleAvatar(child: Text("R")),
      title: Row(
        children: [
          Text(
            room.name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 10),
          Badge(
            label: Text(room.type),
            textColor: Colors.black,
            backgroundColor: Colors.grey,
          ),
        ],
      ),
      subtitle: Text(
        room.lastMsgPreview,
        style: TextStyle(color: Colors.grey)
      ),
      trailing: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color:  Color(0xFF007B73),
          shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${room.unreadMessages}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
      ),
      onTap: () => navigateToPage(context, ChatScreen())
    );
  }

}
