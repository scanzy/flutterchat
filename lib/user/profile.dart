import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';


class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  // TODO: load user data from pocketbase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Text("User id: $userId"),
    );
  }
}
