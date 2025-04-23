import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutterchat/utils/style.dart";


// composes the plural of a word, depending on the count
// examples: 0 messages, 1 message, 2 messages, 3 messages, ...
// TODO: move to string extensions
String plural(String word, int count) => count == 1 ? word : "${word}s";


// goes to the specified page
// replace: false => goes to page, come back if "back" pressed
// replace: true  => goes to page without coming back to the old page

// TODO: extension NavigationContextExtension on BuildContext {
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



// snack bar helpers

// TODO: extension SnackBarContextExtension on BuildContext {
// shows something in a snack bar (temporary bottom bar)
void snackBar(BuildContext context, Widget child) =>
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: context.styles.accent.backgroundColor,
      content: child,
    ),
  );


// shows a text in a snack bar
void snackBarText(BuildContext context, String text) =>
  snackBar(context, Text(text, style: context.styles.accent.txt()));


// shows not implemented in a snack bar
void notImplemented(BuildContext context) =>
  snackBarText(context, "Not implemented");


// debug helpers

// use this as last element of Scaffold actions
// so the debug banner at top right at the screen does not overlap actions
Widget debugBannerSpace() => SizedBox(width: kDebugMode ? 48 : 0);
