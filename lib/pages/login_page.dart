import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    Widget form = Container(
      padding: EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomTextField(
              controller: _idController,
              labelText: "id",
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              labelText: "password",
            ),
          ],
        ),
      ),
    );

    Widget loginButton = CustomButton(
      label: "Login",
      onPressed: () {},
    );

    return Material(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  appLogo,
                  appNameText,
                  SizedBox(height: 48),
                  form,
                  SizedBox(height: 48),
                  loginButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
