import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/utils/style.dart';

import 'package:flutterchat/user/login.dart';
import 'package:flutterchat/user/signup.dart';
import 'package:flutterchat/room/list.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
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
      var pb = PocketBaseService();

      if (pb.client.authStore.isValid) {
        await pb.client.collection('users').authRefresh();
        if (mounted) navigateToPage(context, RoomsListScreen(), replace: true);
        return;
      }
    } catch (e) {
      if (mounted) snackBarText(context, 'Auth check error: ${e.toString()}');
    }
    if (mounted) setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.accent(context),
          )
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showLogin
            ? LoginForm (toggleForm: toggleForm)
            : SignupForm(toggleForm: toggleForm),
        ),
      ),
    );
  }
}
