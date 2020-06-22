import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/pages/loading_page.dart';
import 'package:bibliotek/pages/login_page.dart';
import 'package:bibliotek/pages/role_based_authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Authorization extends StatelessWidget {
  Widget build(BuildContext context) {
    LoginBloc _loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocBuilder<LoginBloc, AbstractLoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, AbstractLoginState loginState) {
        if (loginState is LoginInitialState) {
          _loginBloc.add(CheckLocalStorageEvent());
        }

        if (loginState is LoginLoadingState) {
          return LoadingPage();
        } else if (loginState is UserNotFoundState) {
          return LoginPage();
        } else if (loginState is LoginSuccessState) {
          return RoleBasedAuthorization();
        } else {
          return Container();
        }
      },
    );
  }
}
