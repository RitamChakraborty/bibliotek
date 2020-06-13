import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/add_books_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page.dart';
import 'package:bibliotek/pages/admin_pages/submit_book_page.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_dawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        drawer: CustomDrawer(
          user: User(
            id: "1001",
            password: "admin",
            name: "Librarian",
            isAdmin: true,
            details: {},
          ),
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
