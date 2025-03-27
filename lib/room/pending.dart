// lib/room/pending.dart
/// Handles unverified user state - shows blocking message until account verification
/// This is the digital equivalent of a velvet rope at a club entrance 🚧

import 'package:flutter/material.dart';
import 'package:flutterchat/user/auth.dart';
import 'package:flutterchat/utils/pb_service.dart';
import 'package:flutterchat/room/list.dart';

/// Gatekeeper screen shown when user account isn't verified yet
/// Prevents access to main app features like chat rooms
class PendingPage extends StatelessWidget {
  PendingPage({super.key});

  /// Builds the verification waiting screen with:
  /// - App bar containing logout escape hatch 🚪
  /// - Centered explanatory text block
  /// - Subtle animation to soften the rejection blow 😅
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Verification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => AuthScreen.logout(context),
            tooltip: 'Logout from unverified account',
          ),
        ],
      ),
      body: const _VerificationMessage(),
    );
  }
}

/// Private widget showing the core content message 
/// Separated for easier future theming customization
class _VerificationMessage extends StatelessWidget {
  const _VerificationMessage();


  Future<void> _refreshVerification(BuildContext context) async {
    final pocketbase = PocketBaseService();

    try {
      // 1. Refresh auth status from server
      await pocketbase.client.collection('users').authRefresh();
      
      // 2. Check updated verification status
      AuthScreen().onAuth(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🚨 Error: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_top, size: 60, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              '🔒 Account Pending Verification',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 15),
            Text(
              'Our team of highly trained verification hamsters '
              'is reviewing your details. This usually takes:\n\n'
              '• 1-3 business days\n'
              '• 2 coffee breaks\n'
              '• 1.5 existential crises\n\n'
              'Check back soon! 🐹',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Check Again'),
                onPressed: () => _refreshVerification(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
