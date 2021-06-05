import 'package:flutter/material.dart';

class ButtonChat extends StatefulWidget {
  final onPressed;
  final IconData iconData;
  ButtonChat(this.onPressed, this.iconData);
  @override
  _ButtonChatState createState() => _ButtonChatState();
}

class _ButtonChatState extends State<ButtonChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(22),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        child: Icon(
          widget.iconData,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(0.0),
      ),
    );
  }
}
