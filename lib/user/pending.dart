import 'package:flutter/material.dart';
import 'package:flutterchat/utils/localize.dart';

import 'package:flutterchat/utils/style.dart';
import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/user/auth.dart';


// Handles unverified user state - shows blocking message until account verification
// This is the digital equivalent of a velvet rope at a club entrance 🚧


// gatekeeper screen shown when user account isn't verified yet
// prevents access to main app features like chat rooms
class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  // verification waiting screen with:
  // - app bar containing logout button
  // - centered explanatory text block
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize("user.pending.title")),
        actions: [

          // logout button
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => AuthScreen.logout(context),
            tooltip: 'Logout from unverified account',
          ),

          // prevents debug banner from overlapping action buttons
          debugBannerSpace(),
        ],
      ),
      body: ScrollableCenterPage(
        padding: EdgeInsets.all(AppDimensions.L),
        child: _buildPendingMessage(context),
      ) ,
    );
  }


  // checks if the account has been verified
  Future<void> _refreshVerification(BuildContext context) async {

    try {
      // refresh auth status from server
      await PocketBaseService().client.collection('users').authRefresh();
      if (!context.mounted) return;
      
      // check updated verification status
      AuthScreen().onAuth(context);

    } catch (e) {
      snackBarText(context, '🚨 Error: ${e.toString()}');
    }
  }


  Widget _buildPendingMessage(BuildContext context) {
    return Column(
      spacing: AppDimensions.L,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          Icons.hourglass_top,
          size: AppDimensions.H,
          color: context.styles.background.specialTextColor,
        ),

        Text(
          localize("user.pending.headline"),
          style: context.styles.background.txt(level: 3, size: 2),
        ),

        Text(
          localize("user.pending.hint"),
          textAlign: TextAlign.center,
          style: context.styles.background.txt(size: 1),
        ),

        // recheck button
        ElevatedButton.icon(
          icon: Icon(
            Icons.refresh,
            color: context.styles.accent.normalTextColor,
          ),
          label: Text(localize("user.pending.refresh")),
          onPressed: () => _refreshVerification(context),
          style: context.styles.accent.btn(),
        ),
      ],
    );
  }
}
