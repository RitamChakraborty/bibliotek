import 'package:bibliotek/pages/login_page.dart';
import 'package:bibliotek/pages/role_based_authorization.dart';
import 'package:flutter/material.dart';

class Authorization extends StatelessWidget {
  final bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      return RoleBasedAuthorization();
    } else {
      return LoginPage();
    }
  }
}
