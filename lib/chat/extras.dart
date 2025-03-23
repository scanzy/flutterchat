import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';


// title with date for messages list
class DateTitle extends StatelessWidget {
  final DateTime localDate;
  late final String _formattedDate;

  DateTitle({super.key, required this.localDate}) {

    // calculates the number of days ago
    final now = DateTime.timestamp().utcToAppTz;
    final pastDays = now.difference(localDate).inDays;

    // checks today and yesterday
    if (pastDays == 0) {
      _formattedDate = localize("today").toCapitalized();
      return;
    }
    if (pastDays == 1) {
      _formattedDate = localize("yesterday").toCapitalized();
      return;
    }

    // writes the day of week (e.g. Monday)
    if (pastDays < 7) {
      _formattedDate = localDate.formatLocalized(DateFormat.EEEE).toCapitalized();
      return;
    }

    // formats date normally
    _formattedDate = localDate.formatLocalized(DateFormat.yMMMMd);
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin:  const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: AppStyles.boxNormal(context),
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
      color: AppColors.normal(context),
      padding: EdgeInsets.symmetric(vertical: 8),
      margin:  EdgeInsets.symmetric(vertical: 4),
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
