import 'package:flutter/material.dart';

class Role extends StatelessWidget {
  final Color backColor, circleAvatarColor, avatarColor;
  final String roleType;
  Role({
    @required this.backColor,
    @required this.roleType,
    @required this.avatarColor,
    @required this.circleAvatarColor,
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
            style: Theme.of(context).textTheme.headline5,
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
