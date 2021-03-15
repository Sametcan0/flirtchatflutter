import 'package:flutter/material.dart';


class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mesajlar"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text("Mesajlar"),
        ),
      ),
    );
  }
}
