import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/login_page.dart';
import 'package:bibliotek/pages/role_based_authorization.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;

    if (user == null) {
      return LoginPage();
    } else {
      return RoleBasedAuthorization();
    }
  }
}
