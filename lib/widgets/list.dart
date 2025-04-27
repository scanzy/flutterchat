import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


// improved list tile widget, to avoid strange behaviour of built-in ListTile widget
class CustomListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final double  paddingX;
  final double  paddingY;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.paddingX = 0,
    this.paddingY = 0,
    this.onTap,
    this.onLongPress,
  });


  // builds list tile
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: paddingY),

        child: Row(
          spacing: paddingX,
          children: [

            // leading widget
            if (leading != null) leading!,

            // title and subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  title,
                  if (subtitle != null) subtitle!,
                ],
              ),
            ),

            // trailing widget
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
