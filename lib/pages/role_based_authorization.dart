import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/admin_home_page.dart';
import 'package:bibliotek/pages/student_pages/student_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleBasedAuthorization extends StatefulWidget {
  @override
  _RoleBasedAuthorizationState createState() => _RoleBasedAuthorizationState();
}

class _RoleBasedAuthorizationState extends State<RoleBasedAuthorization> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
//    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, AbstractLoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, AbstractLoginState loginState) {
        if (loginState is LoginSuccessState) {
          User user = loginState.user;

          if (user.isAdmin) {
            return AdminHomePage();
          } else {
            return StudentHomePage();
          }
        } else {
          return Container();
        }
      },
    );
  }
}
