import 'package:flutter/material.dart';

import 'package:flutterchat/chat/screen.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/style.dart';


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
        actions: [

          // logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => PocketBaseService().logout(context),
          ),
        ]
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
          Text(room.name),
          SizedBox(width: 10),
          Badge(
            label: Text(room.type),
            textColor: AppColors.normal(context),
            backgroundColor: AppColors.text(context),
          ),
        ],
      ),
      subtitle: Text(
        room.lastMsgPreview,
        style: AppStyles.textFaded(context),
      ),
      trailing: Container(
        width: 25,
        height: 25,
        decoration: AppStyles.boxAccent(context),
        child: Center(child: Text("${room.unreadMessages}")),
      ),
      onTap: () => navigateToPage(context, ChatScreen())
    );
  }

}
