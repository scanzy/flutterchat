import 'package:flutter/material.dart';
import 'package:flutterchat/utils/misc.dart';


class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

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
      body: Center(
        child: Text("Details here"),
      ),
    );
  }
}
