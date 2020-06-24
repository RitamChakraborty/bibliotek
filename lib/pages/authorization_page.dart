import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/login_page.dart';
import 'package:bibliotek/pages/role_based_authorization.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AuthorizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Consumer(
      builder: (BuildContext context, UserProvider userProvider, Widget child) {
        print('here');
        User user = userProvider.user;

        if (user == null) {
          return BlocProvider<LoginBloc>.value(
            value: LoginBloc(),
            child: LoginPage(),
          );
        } else {
          return RoleBasedAuthorization();
        }
      },
    );
  }
}
