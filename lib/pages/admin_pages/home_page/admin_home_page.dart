import 'package:bibliotek/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:bibliotek/models/admin_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/add_book_page/add_books_page.dart';
import 'package:bibliotek/pages/admin_pages/home_page/show_all_books_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/issue_book_page.dart';
import 'package:bibliotek/pages/admin_pages/submit_book_page/submit_book_page.dart';
import 'package:bibliotek/pages/change_password_page.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User admin = userProvider.user;
    AdminDetail adminDetail = AdminDetail.fromJson(admin.detail);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        drawer: CustomDrawer(
          name: adminDetail.name,
          id: admin.id,
          children: [
            ListTile(
              leading: Icon(Icons.book),
              title: Text("All Books"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return ShowAllBooksPage();
                  }),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Change Password"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: ChangePasswordBloc(),
                      child: ChangePasswordPage(userProvider),
                    );
                  }),
                );
              },
            ),
            Divider(
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text("Logout"),
              onTap: () {
                SchedulerBinding.instance
                    .addPostFrameCallback((timeStamp) async {
                  await userProvider.logOut();
                });
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddBooksPage();
                },
              ),
            );
          },
          label: Text("Add Books"),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  label: "Issue Book",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return IssueBookPage();
                      }),
                    );
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                CustomButton(
                  label: "Submit Book",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SubmitBookPage();
                      }),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
