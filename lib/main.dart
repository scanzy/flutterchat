import 'package:flutter/material.dart';
import 'demo.dart';
import 'scouting1.dart';
import 'scouting2.dart';
import 'converted.dart';
// Add other files with pages here


// Use this variable to select the homepage
// false => show test selection buttons
// true  => show login form (webapp converted)
// after changing the variable, press R to perform hot restart 
bool skipTestSelectionPage = true;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final List<PageInfo> pages = const [
    PageInfo('Webapp converted to dart', AuthWrapper()),
    PageInfo('Chat page - Test 1', ChatPageTest1()),
    PageInfo('Chat page - Test 2', ChatPageTest2()),
    PageInfo('Flutter Demo', DemoPage()),
    // Add new pages here by simply adding new entries
  ];

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF00AFA9),
        scaffoldBackgroundColor: const Color(0xFF0B141A),
        textTheme: const TextTheme(
          bodySmall:  TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: skipTestSelectionPage ? const AuthWrapper() : HomePage(pages: pages),
    );
  }
}

class PageInfo {
  final String title;
  final Widget page;

  const PageInfo(this.title, this.page);
}

class HomePage extends StatelessWidget {
  final List<PageInfo> pages;

  const HomePage({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
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

  Widget _buildPageButton(BuildContext context, PageInfo pageInfo) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
      ),
      onPressed: () => _navigateToPage(context, pageInfo.page),
      child: Text('Go to ${pageInfo.title}'),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
