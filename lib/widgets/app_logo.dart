import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Icon(
        Icons.book,
        color: Theme.of(context).primaryColor,
        size: 100,
      ),
    );
  }
}
