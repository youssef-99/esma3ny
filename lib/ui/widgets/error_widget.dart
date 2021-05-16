import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final IconData iconData;
  final String title;

  Error(this.iconData, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: 35),
          Text(title),
        ],
      ),
    );
  }
}
