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
  LoginBloc loginBloc;
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    idController.text = ID;
    passwordController.text = PASSWORD;

    return Material(
      child: Scaffold(
        body: BlocBuilder<LoginBloc, AbstractLoginState>(
          bloc: loginBloc,
          builder: (BuildContext context, AbstractLoginState loginState) {
            if (loginState is LoginInitialState) {
              ID = "";
              PASSWORD = "";
            } else if (loginState is LoginSuccessState) {
              User user = loginState.user;
              ID = "";
              PASSWORD = "";

              // Wait till widget building is complete
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                userProvider.user = user;
              });

              loginBloc.add(LoginBlocInvokeInitialEvent());
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
                              controller: idController,
                              labelText: "ID",
                              errorText: loginState is LoginErrorState
                                  ? loginState.idErrorMessage
                                  : null,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: passwordController,
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
                                ID = idController.text;
                                PASSWORD = passwordController.text;

                                loginBloc.add(
                                  LoginEvent(
                                    id: idController.text,
                                    password: passwordController.text,
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
