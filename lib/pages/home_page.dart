import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/authorization_page.dart';
import 'package:bibliotek/pages/splash_screen.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sharedPreferencesService.getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data['user'];

          return ChangeNotifierProvider<UserProvider>.value(
            value: UserProvider(user: user),
            builder: (BuildContext context, Widget child) {
              return AuthorizationPage();
            },
          );
        }

        return SplashScreen();
      },
    );
  }
}
