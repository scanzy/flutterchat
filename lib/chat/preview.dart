import 'package:flutter/material.dart';

import 'package:flutterchat/chat/msg.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';


// widget to show a reference to an existing message
class MessagePreview extends StatelessWidget {
  final String? title; // custom first line of preview
  final Message message;
  final int maxLines;
  final VoidCallback? onPressed;

  const MessagePreview({
    super.key,
    this.title,
    required this.message,
    this.onPressed,
    this.maxLines = 1,
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
        decoration: BoxDecoration(
          color: AppColors.normal(context),
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppStyles.shadow(context),
          border: BorderDirectional(
            start: BorderSide(
              width: 4,
              color: AppColors.accent(context),
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
                // uses accent color to self username or custom title
                color: message.isOwn || title != null ?
                  AppColors.accent(context) : message.username.generateColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              message.text,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.textFaded(context),
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

  const MessagePreviewBar({
    super.key,
    this.leadingIcon,
    required this.preview,
    this.onCancel,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.normal(context),
        boxShadow: AppStyles.shadow(context),
      ),
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
              style: AppStyles.btnNormal(context),
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
              style: AppStyles.btnNormal(context),
            ),
        ],
      ),
    );
  }
}
