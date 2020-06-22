import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(
        "Bibliotek",
        style: TextStyle(
          fontSize: 32.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
