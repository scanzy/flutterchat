import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';

import 'package:flutterchat/main.dart';
import 'package:flutterchat/room/model.dart';
import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/chat/screen.dart';
// import 'package:flutterchat/widgets/list.dart';


class FakeRoom with RoomBase {

  // page to open on room list item tap
  final Widget page;

  FakeRoom({
    required name,
    iconCode,
    type,
    description,
    required this.page,
  }) {
    this.name = name;
    this.iconCode = iconCode;
    this.type = type;
    lastMsgPreview = description;
  }
}


final List<FakeRoom> fakeRooms = [

  // adds extra pages
  for (var entry in MyApp.extraPages.entries) ...[
    FakeRoom(
      name: entry.key,
      type: "Extra",
      iconCode: Icons.explore.codePoint,
      page: entry.value,
    )
  ],

  // adds debug pages (only in debug mode)
  if (kDebugMode)
    for (var entry in MyApp.debugPages.entries) ...[
      FakeRoom(
        name: entry.key,
        type: "Debug",
        iconCode: Icons.code.codePoint,
        page: entry.value,
      )
    ],
];


// rooms list
class RoomsListScreen extends StatefulWidget {
  const RoomsListScreen({super.key});

  @override
  State<StatefulWidget> createState() => RoomsListScreenState();
}


class RoomsListScreenState extends State<RoomsListScreen> {

  final List<RoomBase> _rooms = [];

  @override
  void initState() {
    super.initState();
    loadRooms();
  }


  // loads rooms data
  Future<void> loadRooms() async {
    final allRooms = await RoomFactory().all();
    if (!mounted) return;
    setState(() {
      _rooms.clear();
      _rooms.addAll(allRooms);
      _rooms.addAll(fakeRooms);
    });
  }


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
          padding: EdgeInsets.all(AppDimensions.M),
          alignment: Alignment.center,
          child: Text(
            'Here are all the rooms',
            style: context.styles.background.txt(),
          ),
        ),

        // rooms
        Expanded(
          child: ListView.separated(
            // controller: _scrollController,
            itemCount: _rooms.length,
            itemBuilder: (context, index) => _buildRoomRow(context, _rooms[index]),

            // items separator
            separatorBuilder: (context, index) => Divider(
              indent: 2 * (AppDimensions.L + AppDimensions.M), // 2 * (avatar radius and padding)
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
  Widget _buildRoomRow(BuildContext context, RoomBase room) {

    // gets the page to navigate to, on room tap
    late final Widget? page;
    if (room is Room)     page = ChatScreen(room: room);
    if (room is FakeRoom) page = room.page;

    // styles configurations
    final avatarStyleGroup = context.styles.basic;
    final tileStyleGroup   = context.styles.background;
    final badgeStyleGroup  = context.styles.basic;
    final unreadStyleGroup = context.styles.accent;

    return ListTile(

    // use this for easier configuration
    // return CustomListTile(
      //paddingX: AppDimensions.M,
      //paddingY: AppDimensions.S,

      // room avatar
      leading: CircleAvatar(
        radius: AppDimensions.L,
        foregroundColor: avatarStyleGroup.normalTextColor,
        backgroundColor: avatarStyleGroup.backgroundColor,

        // icon or first letter of room name
        child: (room.iconCode != null)
          ? Icon(IconData(room.iconCode!, fontFamily: "MaterialIcons"))
          : Text(room.name[0], style: avatarStyleGroup.txt()),
      ),

      // first row
      title: Row(
        spacing: AppDimensions.M,
        children: [
          Expanded(child: Row(
            spacing: AppDimensions.M,
            children: [

              // room title
              Text(room.name, style: tileStyleGroup.txt(level: 3)),

              // room type badge
              if (room.type != null)
                Badge(
                  label: Text(room.type!, style: badgeStyleGroup.txt()),
                  backgroundColor: badgeStyleGroup.backgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 2 * AppDimensions.S),
                ),
            ],
          )),

          // last updated time or date
          room.lastUpdate == null ? SizedBox() :
          Text(
            room.lastUpdate!.prettyFormat(time: true),
            style: tileStyleGroup.txt(level: 1),
          ),
        ],
      ),

      // second row
      subtitle: Row(
        spacing: AppDimensions.M,
        children: [

          // message prewiew (if any)
          Expanded(child:
            (room.lastMsgPreview == null) ? Text("\n") :
            Text(
              "${room.lastMsgPreview!}\n",
              style: tileStyleGroup.txt(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // unread messages count
          (room.unreadMessages ?? 0) == 0 ? SizedBox() :
          Badge.count(
            count: room.unreadMessages!,
            padding: EdgeInsets.all(AppDimensions.S),
            textStyle: unreadStyleGroup.txt(size: 1),
            textColor: unreadStyleGroup.normalTextColor,
            backgroundColor: unreadStyleGroup.backgroundColor,
          ),
        ],
      ),

      // goes to corresponding room
      onTap: () { if (page != null) navigateToPage(context, page); },
    );
  }

}
