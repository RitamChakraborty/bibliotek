import 'package:bibliotek/bloc/login_bloc.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

    Widget appLogo = Container(
      padding: EdgeInsets.all(8),
      child: Icon(
        Icons.book,
        color: Theme.of(context).primaryColor,
        size: 100,
      ),
    );

    Widget appNameText = Container(
      padding: EdgeInsets.all(8),
      child: Text(
        "Bibliotek",
        style: TextStyle(
          fontSize: 32.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    );

    return Material(
      child: Scaffold(
        body: BlocBuilder<LoginBloc, AbstractLoginState>(
          bloc: loginBloc,
          builder: (BuildContext context, AbstractLoginState loginState) {
            if (loginState is LoadingState) {
              print('loading');
            } else if (loginState is ErrorState) {
              print('errorstate');
              print("iderror: ${loginState.idErrorMessage}");
              print("pderror: ${loginState.passwordErrorMessage}");
            } else if (loginState is LoginSuccessState) {
              print('loginsuccess');
            } else if (loginState is InitialState) {
              print('initial');
            } else {
              print('somethingelse');
            }

            return Container(
              alignment: Alignment.center,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      appLogo,
                      appNameText,
                      SizedBox(height: 48),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                              controller: _idController,
                              labelText: "id",
                              errorText: loginState is ErrorState
                                  ? loginState.idErrorMessage
                                  : null,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              labelText: "password",
                              errorText: loginState is ErrorState
                                  ? loginState.passwordErrorMessage
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 48),
                      CustomButton(
                        label: loginState is LoadingState ? "Loading" : "Login",
                        onPressed: () {
                          print('adding event');
                          loginBloc.add(
                            LoginEvent(
                                id: _idController.text,
                                password: _passwordController.text),
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
