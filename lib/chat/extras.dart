import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/constants.dart';
import 'package:flutterchat/utils/misc.dart';


// title with date for messages list
class DateTitle extends StatelessWidget {
  final DateTime date;
  late final String _formattedDate;

  DateTitle({super.key, required this.date}) {

    // calculates the number of days ago
    final now = DateTime.now();
    final pastDays = now.difference(date).inDays;

    // checks today and yesterday
    if (pastDays == 0) {
      _formattedDate = "Today";
      return;
    }
    if (pastDays == 1) {
      _formattedDate = "Yesterday";
      return;
    }

    // writes the day of week (e.g. Monday)
    if (pastDays < 7) {
      _formattedDate = DateFormat.EEEE(locale).format(date);
      return;
    }

    // formats date normally
    _formattedDate = DateFormat.yMMMMd(locale).format(date);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1F2C34),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              _formattedDate,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
          ),
          ),
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
      color: const Color(0xFF007B73),
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Text(
          count != null ? "Unread messages" :
            "$count unread ${plural('message', count ?? 0)}",
          style: TextStyle(
            // color: Colors.grey[600],
            //fontSize: 12,
          ),
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
        backgroundColor: const Color(0xFF1F2C34),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.arrow_downward),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF1F2C34),
      foregroundColor: Colors.white,
      child: const Icon(Icons.arrow_downward),
    );
  }
}
