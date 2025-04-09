import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/style.dart';

import 'package:flutterchat/user/login.dart';
import 'package:flutterchat/user/signup.dart';
import 'package:flutterchat/user/pending.dart';
import 'package:flutterchat/room/list.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();

  // called when user is authenticated: goes to the right page
  void onAuth(BuildContext context) {
  
      // checks if user is verified or not
      final user = PocketBaseService().currentUser;
      final isVerified = user?.data['verified'] ?? false;

      // unverified users go to waiting page, rooms list otherwise
      navigateToPage(
        context,
        isVerified ? RoomsListScreen() : PendingPage(),
        replace: true,
      );
  }


  // callback for logout button
  static void logout(BuildContext context) {

    // removes stored auth info
    PocketBaseService().logout();

    // returns to login page
    navigateToPage(context, const AuthScreen(), replace: true);
  }
}

class AuthScreenState extends State<AuthScreen> {
  bool _isLoading = true;
  bool _showLogin = true;

  void toggleForm() => setState(() => _showLogin = !_showLogin);


  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      // tries to check the auth store
      if (await PocketBaseService().autoLogin()) {
        if (!mounted) return;

        // Triggering the verification check through onAuth
        widget.onAuth(context);
        return;
      }
    } catch (e) {
      if (mounted) snackBarText(context, 'Auth check error: ${e.toString()}');
    }

    // hides loading indicator and shows login form
    if (mounted) setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: context.styles.background.specialTextColor,
          )
        ),
      );
    }

    return Scaffold(
      body: ScrollableCenterPage(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showLogin
            ? LoginForm (toggleForm: toggleForm, onAuth: widget.onAuth)
            : SignupForm(toggleForm: toggleForm, onAuth: widget.onAuth),
        ),
      ),
    );
  }
}
