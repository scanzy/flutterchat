import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';


// title with date for messages list
class DateTitle extends StatelessWidget {
  final DateTime localDate;
  late final String _formattedDate;


  // uses pretty format (e.g. "today", "yesterday", "monday"), if possible
  DateTitle({super.key, required this.localDate}) {
    _formattedDate = localDate.prettyFormat(time: false);
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin:  EdgeInsets.all(AppDimensions.L),
        padding: EdgeInsets.all(2 * AppDimensions.S),
        decoration: context.styles.basic.box(rounded: true),
        child: Text(
          _formattedDate,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


// Title "unread messages"
class UnreadMessagesTitle extends StatelessWidget {
  final int? count;
  const UnreadMessagesTitle({super.key, this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.styles.basic.box(),
      padding: EdgeInsets.symmetric(vertical: 2 * AppDimensions.S),
      margin:  EdgeInsets.symmetric(vertical: AppDimensions.S),
      child: Center(
        child: Text(
          count != null ? "Unread messages" :
            "$count unread ${plural('message', count ?? 0)}",
        ),
      ),
    );
  }
}


// button to jump to last message
class JumpToLastMessageButton extends StatelessWidget {

  final int newMessages;
  final VoidCallback onPressed;
  const JumpToLastMessageButton({
    super.key,
    required this.newMessages,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    if (newMessages > 0) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        // count of messages arrived when viewing old ones
        label: Text("$newMessages new ${plural('message', newMessages)}"),
        icon: const Icon(Icons.arrow_downward),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.arrow_downward),
    );
  }
}
