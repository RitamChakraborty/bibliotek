import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/authorization_page.dart';
import 'package:bibliotek/pages/splash_screen.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  final FirestoreServices _firestoreServices = FirestoreServices();

  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sharedPreferencesService.getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // Data fetched from SharedPreferences
          String refId = snapshot.data['ref_id'];

          return StreamBuilder<User>(
            stream: _firestoreServices.getUserFromReferenceId(refId: refId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // Data fetched from Cloud Firestore
                return ChangeNotifierProvider<UserProvider>.value(
                  value: UserProvider(user: snapshot.data),
                  child: AuthorizationPage(),
                );
              }

              return SplashScreen();
            },
          );
        }

        return SplashScreen();
      },
    );
  }
}
