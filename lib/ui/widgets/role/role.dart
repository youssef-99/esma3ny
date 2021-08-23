import 'package:flutter/material.dart';

class Role extends StatelessWidget {
  final Color backColor, circleAvatarColor, avatarColor, textColor;
  final String roleType;
  Role({
    @required this.backColor,
    @required this.roleType,
    @required this.avatarColor,
    @required this.circleAvatarColor,
    @required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor,
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            roleType,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 40,
            backgroundColor: circleAvatarColor,
            child: Icon(
              Icons.person,
              size: 40,
              color: avatarColor,
            ),
          ),
        ],
      ),
    );
  }
}
