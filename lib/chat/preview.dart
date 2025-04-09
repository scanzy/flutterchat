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
        padding: EdgeInsets.all(2 * AppDimensions.S),
        decoration: styleGroup.box(rounded: true, shadow: true).copyWith(
          border: BorderDirectional(
            start: BorderSide(
              width: AppDimensions.S,
              color: styleGroup.specialTextColor,
            ),
          ),
        ),
        child: Column(
          spacing: AppDimensions.S,
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

      padding: EdgeInsets.all(2 * AppDimensions.S),
      child: Row(
        spacing: 2 * AppDimensions.S,
        children: [

          // leading icon
          if (leadingIcon != null)
            IconButton(
              icon: Icon(leadingIcon),
              onPressed: null,
              iconSize: AppDimensions.X,
              padding: EdgeInsets.all(2 * AppDimensions.S),
              style: group.btn(),
            ),

          // message preview
          Expanded(child: preview),

          // trailing close icon
          if (onCancel != null)
            IconButton(
              onPressed: onCancel,
              icon: Icon(Icons.close),
              iconSize: AppDimensions.X,
              padding: EdgeInsets.all(2 * AppDimensions.S),
              style: group.btn(),
            ),
        ],
      ),
    );
  }
}
