import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/pages/authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>.value(value: LoginBloc()),
        BlocProvider<BookBloc>.value(value: BookBloc()),
      ],
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
