import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/widgets/app_logo.dart';
import 'package:bibliotek/widgets/app_name.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    _idController.text = ID;
    _passwordController.text = PASSWORD;

    return Material(
      child: Scaffold(
        body: BlocBuilder<LoginBloc, AbstractLoginState>(
          bloc: _loginBloc,
          builder: (BuildContext context, AbstractLoginState loginState) {
            if (loginState is LoginSuccessState) {
              User user = loginState.user;
              ID = "";
              PASSWORD = "";

              // Wait till widget building is complete
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                userProvider.setUser(user);
              });
            }

            return Container(
              alignment: Alignment.center,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AppLogo(),
                      SizedBox(height: 16),
                      AppName(),
                      SizedBox(height: 48),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                              controller: _idController,
                              labelText: "ID",
                              errorText: loginState is LoginErrorState
                                  ? loginState.idErrorMessage
                                  : null,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              labelText: "Password",
                              errorText: loginState is LoginErrorState
                                  ? loginState.passwordErrorMessage
                                  : null,
                              isPassword: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 48),
                      CustomButton(
                        label: loginState is LoginLoadingState
                            ? "Loading"
                            : "Login",
                        onPressed: loginState is LoginLoadingState
                            ? null
                            : () {
                                ID = _idController.text;
                                PASSWORD = _passwordController.text;

                                _loginBloc.add(
                                  LoginEvent(
                                    id: _idController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
