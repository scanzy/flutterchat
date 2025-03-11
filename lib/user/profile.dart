import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';


class ProfileScreen extends StatelessWidget {
  final RecordModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Text("Username: ${user.get<String>("username")}"),
    );
  }
}
