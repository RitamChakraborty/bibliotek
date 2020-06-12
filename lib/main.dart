import 'package:bibliotek/bloc/login_bloc.dart';
import 'package:bibliotek/pages/authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: LoginBloc(),
      child: MaterialApp(
        title: 'Bibliotek',
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.pinkAccent,
        ),
        home: Authorization(),
      ),
    );
  }
}
