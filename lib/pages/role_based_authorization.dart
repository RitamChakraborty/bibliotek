import 'package:bibliotek/pages/admin_pages/admin_home_page.dart';
import 'package:bibliotek/pages/student_pages/student_home_page.dart';
import 'package:flutter/material.dart';

class RoleBasedAuthorization extends StatelessWidget {
  final bool _isStudent = true;

  @override
  Widget build(BuildContext context) {
    if (_isStudent) {
      return StudentHomePage();
    } else {
      return AdminHomePage();
    }
  }
}
