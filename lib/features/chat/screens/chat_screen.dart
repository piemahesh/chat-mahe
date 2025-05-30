import 'package:flutter/material.dart';
import 'package:flutter_my_app/features/drawer/index.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("hello"), backgroundColor: Colors.amberAccent),
      body: Column(children: [Text("chat 1")]),
      drawer: AppDrawer(),
    );
  }
}
