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

    // adds extra pages
    for (var page in MyApp.extraPages.entries) ...[
      Room(
        name: page.key,
        type: "Extra",
        icon: Icons.explore,
        onTap: (context) => navigateToPage(context, page.value),
      )
    ],

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
          child: Text(
            'Here are all the rooms',
            style: context.styles.background.txt(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            // controller: _scrollController,
            itemCount: rooms.length,
            itemBuilder: (context, index) => _buildRoomRow(context, rooms[index]),

            // items separator
            separatorBuilder: (context, index) => Divider(
              indent: AppDimensions.H,
              height: AppDimensions.line,
              thickness: AppDimensions.line,
              color: context.styles.background.fadedTextColor,
            ),
          ),
        ),
      ]),
    );
  }


  // room list item
  Widget _buildRoomRow(BuildContext context, Room room) {

    // styles configurations
    final avatarStyleGroup = context.styles.basic;
    final tileStyleGroup   = context.styles.background;
    final badgeStyleGroup  = context.styles.basic;
    final unreadStyleGroup = context.styles.accent;

    return ListTile(

      // room avatar
      leading: CircleAvatar(
        foregroundColor: avatarStyleGroup.normalTextColor,
        backgroundColor: avatarStyleGroup.backgroundColor,
        child: (room.icon != null) ? Icon(room.icon)
          : Text(room.name[0], style: avatarStyleGroup.txt()),
      ),

      // room title
      title: Row(
        spacing: AppDimensions.M,
        children: [
          Text(
            room.name,
            style: tileStyleGroup.txt(level: 3),
          ),
          if (room.type != null)
            Badge(
              label: Text(room.type!, style: badgeStyleGroup.txt()),
              backgroundColor: badgeStyleGroup.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 2 * AppDimensions.S),
            ),
        ],
      ),
      subtitle:
        (room.lastMsgPreview == null) ? null :
        Text(
          room.lastMsgPreview!,
          style: tileStyleGroup.txt(),
        ),

      // unread messages count
      trailing:
        (room.unreadMessages ?? 0) == 0 ? null :
        Badge.count(
          count: room.unreadMessages!,
          padding: EdgeInsets.all(AppDimensions.S),
          largeSize: AppDimensions.M,
          textStyle: unreadStyleGroup.txt(),
          textColor: unreadStyleGroup.normalTextColor,
          backgroundColor: unreadStyleGroup.backgroundColor,
        ),

      // goes to corresponding room
      onTap: () => (room.onTap ?? notImplemented)(context),
    );
  }

}
