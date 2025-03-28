import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';

import 'package:flutterchat/main.dart';
import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/chat/screen.dart';


class Room {
  final String name;
  final IconData? icon;
  final String? type;
  final String? lastMsgPreview;
  final DateTime? lastCreated;
  final int? unreadMessages;
  final Function(BuildContext)? onTap;

  Room({
    required this.name,
    this.icon,
    this.type,
    this.lastMsgPreview,
    this.lastCreated,
    this.unreadMessages,
    this.onTap,
  });
}


// rooms list
class RoomsListScreen extends StatelessWidget {
  RoomsListScreen({super.key});

  final List<Room> rooms = [
    Room(
      name: "Branco",
      type: "Generale",
      icon: Icons.public,
      lastMsgPreview: "user: Ciao uomini!",
      lastCreated: DateTime.now(),
      unreadMessages: 10,
      onTap: (context) => navigateToPage(context, ChatScreen()),
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

    // adds debug pages (only in debug mode)
    if (kDebugMode)
      for (var page in MyApp.debugPages.entries) ...[
        Room(
          name: page.key,
          type: "Debug",
          icon: Icons.code,
          onTap: (context) => navigateToPage(context, page.value),
        )
      ],
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize("shared.title")),
        actions: [

          // app version button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              if (!context.mounted) return;
              snackBarText(context, "App version: ${packageInfo.version}");
            },
          ),

          // logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthScreen.logout(context),
          ),

          // prevents overlapping between bebug banner and last action
          debugBannerSpace(),
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

      leading: CircleAvatar(
        child: (room.icon != null) ? Icon(room.icon) : Text(room.name[0]),
      ),
      title: Row(
        children: [
          Text(room.name),
          SizedBox(width: 10),
          if (room.type != null)
            Badge(
              label: Text(room.type!),
              textColor: AppColors.normal(context),
              backgroundColor: AppColors.text(context),
            ),
        ],
      ),
      subtitle:
        (room.lastMsgPreview == null) ? null :
        Text(
          room.lastMsgPreview!,
          style: AppStyles.textFaded(context),
        ),
      trailing:
        (room.unreadMessages ?? 0) == 0 ? null :
        Container(
          width: 25,
          height: 25,
          decoration: AppStyles.boxAccent(context),
          child: Center(child: Text("${room.unreadMessages}")),
        ),
      onTap: () => (room.onTap ?? notImplemented)(context),
    );
  }

}
