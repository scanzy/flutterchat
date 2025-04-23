import 'package:flutter/material.dart';

import 'package:flutterchat/utils/misc.dart';
import 'package:flutterchat/utils/style.dart';

import 'package:flutterchat/user/model.dart';


class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  // TODO: load user data from pocketbase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ScrollableCenterPage(
        child: Column(
          spacing: AppDimensions.L,
          children: [

            // username
            Text(
              user.username,
              style: context.styles.background.txt(level: 3, size: 2),
            ),

            Text(
              user.email,
              style: context.styles.background.txt(),
            ),

            // TODO: other user details
          ],
        )
      ),
    );
  }
}
