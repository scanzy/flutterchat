import 'package:flutter/material.dart';

import 'package:flutterchat/chat/screen.dart';
import 'package:flutterchat/utils/misc.dart';


// rooms list
class RoomsListScreen extends StatelessWidget {
  const RoomsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Room list here:"),
      TextButton(
        onPressed: () => navigateToPage(context, ChatScreen()),
        child: Text("Go to Room"),
      ),
    ]);
  }

}
