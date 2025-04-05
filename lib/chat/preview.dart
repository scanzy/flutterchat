import 'package:flutter/material.dart';

import 'package:flutterchat/chat/msg.dart';
import 'package:flutterchat/utils/localize.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';


// widget to show a reference to an existing message
class MessagePreview extends StatelessWidget {
  final String? title; // custom first line of preview
  final Message message;
  final int maxLines;
  final VoidCallback? onPressed;
  final StyleGroup styleGroup;

  const MessagePreview({
    super.key,
    this.title,
    required this.message,
    this.onPressed,
    this.maxLines = 1,
    required this.styleGroup,
  });

  @override
  Widget build(BuildContext context) {

    // clickable container
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
      onTap: onPressed,

      // rounded normal box with shadow and left accent border
      child: Container(
        margin:  EdgeInsets.symmetric(vertical: 12),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: styleGroup.box(rounded: true, shadow: true).copyWith(
          border: BorderDirectional(
            start: BorderSide(
              width: 4,
              color: styleGroup.specialTextColor,
            ),
          ),
        ),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? message.username,
              maxLines: maxLines,
              style: TextStyle(

                // uses random color for others' username
                // uses special color to self username or custom title
                color: message.isOwn || title != null ?
                  styleGroup.specialTextColor : message.username.generateColor(styleGroup),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              // shows "message deleted" if needed
              message.justDeleted ?
                localize("chat.msg.deleted").toCapitalized()
                : message.text,
              overflow: TextOverflow.ellipsis,
              style: styleGroup.txt(),
            ),
          ],
        ),
      )),
    );
  }
}


// widget to show a removable reference to a message
class MessagePreviewBar extends StatelessWidget {
  final IconData? leadingIcon;
  final MessagePreview preview;
  final VoidCallback? onCancel; // cancel button is shown only if callback specified
  final StyleGroup? styleGroup;

  const MessagePreviewBar({
    super.key,
    this.leadingIcon,
    required this.preview,
    this.onCancel,
    this.styleGroup,
  });


  @override
  Widget build(BuildContext context) {

    // uses configured style group, or basic as fallback
    final group = styleGroup ?? context.styles.basic;
    return Container(
      decoration: group.box(shadow: true),

      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        spacing: 8,
        children: [

          // leading icon
          if (leadingIcon != null)
            IconButton(
              icon: Icon(leadingIcon),
              onPressed: null,
              iconSize: 32,
              padding: EdgeInsets.all(8),
              style: group.btn(),
            ),

          // message preview
          Expanded(child: preview),

          // trailing close icon
          if (onCancel != null)
            IconButton(
              onPressed: onCancel,
              icon: Icon(Icons.close),
              iconSize: 32,
              padding: EdgeInsets.all(8),
              style: group.btn(),
            ),
        ],
      ),
    );
  }
}
