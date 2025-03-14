import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';

import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/palette.dart';
import 'package:flutterchat/scouting2.dart';
// Add other files with pages here


// Use this variable to select the homepage
// false => show test selection buttons
// true  => show login form (webapp converted)
// after changing the variable, press R to perform hot restart
bool skipTestSelectionPage = true;


// main entry point of the app
void main() async {

  // sets up pocket base service (auto-login)
  await PocketBaseService().setup();

  // provides italian localization for date and time
  initializeDateFormatting("it");

  // starts the application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<PageInfo> pages = [
    PageInfo('Full app',    AuthScreen()),
    PageInfo('App colors',  PalettePage()),
    PageInfo('Chat test 2', ChatPageTest2()),
    // Add new pages here by simply adding new entries
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: skipTestSelectionPage ? const AuthScreen() : HomePage(pages: pages),
    );
  }
}


class PageInfo {
  final String title;
  final Widget page;

  const PageInfo(this.title, this.page);
}


// page picker
class HomePage extends StatelessWidget {
  final List<PageInfo> pages;

  const HomePage({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final pageInfo in pages) ...[
                _buildPageButton(context, pageInfo),
                const SizedBox(height: 20),
              ],
            ]..removeLast(), // Remove last SizedBox
          ),
        ),
      ),
    );
  }


  // button to go to linked page
  Widget _buildPageButton(BuildContext context, PageInfo pageInfo) {
    return ElevatedButton(
      style: AppStyles.btnAccent(context).merge(
        ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
      ),
      onPressed: () => navigateToPage(context, pageInfo.page),
      child: Text('Go to ${pageInfo.title}'),
    );
  }

}
