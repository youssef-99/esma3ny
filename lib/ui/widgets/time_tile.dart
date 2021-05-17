import 'package:flutter/material.dart';

class TimeTile extends StatefulWidget {
  final bool isPressed;
  TimeTile(this.isPressed);
  @override
  _TimeTileState createState() => _TimeTileState();
}

class _TimeTileState extends State<TimeTile> {
  Color color = Colors.grey;
  bool isPressed;
  @override
  void initState() {
    if (widget.isPressed)
      isPressed = true;
    else
      isPressed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: isPressed ? Colors.blue : Colors.grey),
      child: Text('9:00 pm'),
      onPressed: () {
        setState(() {
          isPressed = !isPressed;
        });
      },
    );
  }
}
