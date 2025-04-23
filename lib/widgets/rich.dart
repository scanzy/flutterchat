import "package:flutter/material.dart";
import "package:flutter/gestures.dart";

import 'package:url_launcher/url_launcher.dart';
import "package:flutterchat/utils/style.dart";


// adds methods to strings
extension StringCasingExtension on String {

  // only first capital letter
  String toCapitalized() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  } 

  // generates color from string
  // optimizes color lightness to be visible on the background ot supplied styleGroup
  Color generateColor(StyleGroup? styleGroup) {

    // gets proper brightness
    final backgroundColor = styleGroup?.backgroundColor ?? Colors.black;
    final brightness = backgroundColor.computeLuminance() > 0.5 ? 0.4 : 0.5;

    // generates color
    return HSLColor.fromAHSL(1.0, (hashCode % 360).toDouble(), 0.8, brightness).toColor();
  }
}


// composes rich text, recognizing links and formatting them
Widget parseLinks(String text, {TextStyle? style}) {
  final urlRegex = RegExp(r'(https?://[^\s]+)');
  final spans = <TextSpan>[];

  text.splitMapJoin(
    urlRegex,

    // formats links properly
    onMatch: (match) {
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: TextStyle(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        ),

        // opens link in browser on tap
        recognizer: TapGestureRecognizer()
          ..onTap = () => launchUrl(Uri.parse(url)),
      ));
      return '';
    },

    // leaves other text untouched
    onNonMatch: (text) {
      spans.add(TextSpan(text: text));
      return '';
    },
  );

  // composes text joining processed chuncks
  return Text.rich(TextSpan(children: spans), style: style);
}
