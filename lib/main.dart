import 'package:bibliotek/bloc/shared_preferences_services_bloc/shared_preferences_services_bloc.dart';
import 'package:bibliotek/pages/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: SharedPreferencesServicesBloc(),
      child: MaterialApp(
        title: 'Bibliotek',
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.pinkAccent,
        ),
        home: Test(),
      ),
    );
  }
}
