import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/admin_home_page.dart';
import 'package:bibliotek/pages/login_pages/login_page.dart';
import 'package:bibliotek/pages/splash_screen.dart';
import 'package:bibliotek/pages/student_pages/student_home_page.dart';
import 'package:bibliotek/providers/firestore_provider.dart';
import 'package:bibliotek/providers/local_storeage_provider.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    FireStoreProvider firestore = Provider.of<FireStoreProvider>(context);
    LocalStorageProvider localStorage =
        Provider.of<LocalStorageProvider>(context);
    User user = userProvider.user;

    if (user != null) {
      if (user.isAdmin) {
        return AdminHomePage();
      } else {
        return StudentHomePage();
      }
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: localStorage.getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          String refId = snapshot.data['ref_id'];
          if (refId != null) {
            return StreamBuilder<User>(
              stream: firestore.getUserById(refId: refId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data;
                  user.refId = refId;

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
