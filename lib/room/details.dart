import 'package:flutter/material.dart';


class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room details'),
      ),
      body: Center(
        child: Text("Details here"),
      ),
    );
  }
}
