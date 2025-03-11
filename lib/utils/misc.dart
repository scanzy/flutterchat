import "package:flutter/material.dart";


// composes the plural of a word, depending on the count
// examples: 0 messages, 1 message, 2 messages, 3 messages, ...
String plural(String word, int count) => count == 1 ? word : "${word}s";


void navigateToPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
