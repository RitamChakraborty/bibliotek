import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/admin_home_page.dart';
import 'package:bibliotek/pages/student_pages/student_home_page.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleBasedAuthorization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;

    if (user.isAdmin) {
      return AdminHomePage();
    } else {
      return StudentHomePage();
    }
  }
}
