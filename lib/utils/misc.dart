import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import 'package:url_launcher/url_launcher.dart';


// composes the plural of a word, depending on the count
// examples: 0 messages, 1 message, 2 messages, 3 messages, ...
String plural(String word, int count) => count == 1 ? word : "${word}s";


// generates color from string
Color generateColor(String seed) {
  final hash = seed.hashCode;
  return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.7, 0.5).toColor();
}


// goes to the specified page
void navigateToPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}


// composes rich text, recognizing links and formatting them
Widget parseLinks(String text, Color color) {
  final urlRegex = RegExp(r'(https?://[^\s]+)');
  final spans = <TextSpan>[];

  text.splitMapJoin(
    urlRegex,

    // formats links properly
    onMatch: (match) {
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(
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
      spans.add(TextSpan(text: text, style: TextStyle(color: color)));
      return '';
    },
  );

  // composes text joining processed chuncks
  return RichText(text: TextSpan(children: spans));
}
