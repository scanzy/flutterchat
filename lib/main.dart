import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/style.dart';

import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/dev/styles.dart';
import 'package:flutterchat/dev/scouting2.dart';
// Add other files with debug or scouting pages here



// main entry point of the app
void main() async {

  // sets up pocket base service, configuring auth store
  await PocketBaseService().setup();

  // provides italian localization for date and time
  initializeDateFormatting("it");

  // starts the application
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  static final Map<String, Widget> debugPages = {
    'App styles':  StylesPage(),
    'Chat test 2': ChatPageTest2(),
    // Add new debug or scouting pages here by simply adding new entries
  };


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: const AuthScreen(),
    );
  }
}
