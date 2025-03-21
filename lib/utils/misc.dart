import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "package:flutter/foundation.dart";
import 'package:url_launcher/url_launcher.dart';


// composes the plural of a word, depending on the count
// examples: 0 messages, 1 message, 2 messages, 3 messages, ...
String plural(String word, int count) => count == 1 ? word : "${word}s";


// goes to the specified page
// replace: false => goes to page, come back if "back" pressed
// replace: true  => goes to page without coming back to the old page
void navigateToPage(BuildContext context, Widget page, {bool replace = false}) {
  final func = replace ? Navigator.pushReplacement : Navigator.push;
  func(context, MaterialPageRoute(builder: (context) => page));
}


// scrollable container for page with static content
// on large screens: content is be centered
// on small screens: page scrolls, with padding
class ScrollableCenterPage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const ScrollableCenterPage({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        primary: true,
        padding: padding,
        child: Center(child: child),
      )
    );
  }
}


// formatting helpers

// generates color from string
Color generateColor(String seed) {
  final hash = seed.hashCode;
  return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.7, 0.5).toColor();
}


// composes rich text, recognizing links and formatting them
Widget parseLinks(String text, {Color? color}) {
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


// snack bar helpers

// shows something in a snack bar (temporary bottom bar)
void snackBar(BuildContext context, Widget child) =>
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: child));

// shows a text in a snack bar
void snackBarText(BuildContext context, String text) =>
  snackBar(context, Text(text));

// shows not implemented in a snack bar
void notImplemented(BuildContext context) =>
  snackBarText(context, "Not implemented");


// debug helpers

// use this as last element of Scaffold actions
// so the debug banner at top right at the screen does not overlap actions
Widget debugBannerSpace() => SizedBox(width: kDebugMode ? 48 : 0);
