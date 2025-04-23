import 'package:flutter/material.dart';
import 'package:flutterchat/room/model.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';


class RoomDetailsScreen extends StatelessWidget {
  final Room room;
  const RoomDetailsScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room details'),
        actions: [

          // prevents overlapping between bebug banner and last action
          debugBannerSpace(),
        ]
      ),
      body: ScrollableCenterPage(
        child: Column(
          spacing: AppDimensions.L,
          children: [

            // room name
            Text(
              room.name,
              style: context.styles.background.txt(level: 3, size: 2),
            ),

            // room description
            Text(
              room.description ?? "",
              style: context.styles.background.txt(),
            ),
          ],
        ),
      ),
    );
  }
}
