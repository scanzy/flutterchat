import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/localize.dart';

import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/dev/styles.dart';
import 'package:flutterchat/dev/scouting2.dart';
import 'package:flutterchat/dev/localize.dart';
// Add other files with debug or scouting pages here



// main entry point of the app
void main() async {

  // sets up pocket base service, configuring auth store
  await PocketBaseService().setup();

  // provides localization for date and time
  AppLocalization.init();

  // starts the application
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static final Map<String, Widget> debugPages = {
    'App styles':  StylesPage(),
    'Chat test 2': ChatPageTest2(),
    'Localization': LocalizationPage(),
    // Add new debug or scouting pages here by simply adding new entries
    // It's ok if you don't use app localization in debug pages
  };
}


class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // on web, disable the browser's context menu
    if (kIsWeb) BrowserContextMenu.disableContextMenu();
  }


 @override
  void dispose() {
    // on web, re-enable browser's context menu again
    if (kIsWeb) BrowserContextMenu.enableContextMenu();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: localize("shared.title"), // title for web
      theme: appTheme,
      home: const AuthScreen(),
    );
  }
}
