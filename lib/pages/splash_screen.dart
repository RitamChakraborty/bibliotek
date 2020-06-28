import 'package:bibliotek/widgets/app_logo.dart';
import 'package:bibliotek/widgets/app_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppLogo(),
          SizedBox(height: 56),
          AppName(),
        ],
      ),
    );
  }
}
