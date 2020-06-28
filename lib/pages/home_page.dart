import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/admin_home_page.dart';
import 'package:bibliotek/pages/login_page.dart';
import 'package:bibliotek/pages/splash_screen.dart';
import 'package:bibliotek/pages/student_pages/student_home_page.dart';
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;

    if (user != null) {
      if (user.isAdmin) {
        return AdminHomePage();
      } else {
        return StudentHomePage();
      }
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _sharedPreferencesService.getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          String refId = snapshot.data['ref_id'];
          if (refId != null) {
            return StreamBuilder<User>(
              stream: _firestoreServices.getUserFromReferenceId(refId: refId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    userProvider.user = user;
                  });

                  return SplashScreen();
                }

                return SplashScreen();
              },
            );
          }

          return LoginPage();
        }

        return SplashScreen();
      },
    );
  }
}
