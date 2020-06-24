import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/show_all_books_page.dart';
import 'package:bibliotek/pages/student_pages/search_book_page.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User student = userProvider.user;
    StudentDetail studentDetail = StudentDetail.fromJson(student.detail);

    Widget drawer = CustomDrawer(
      id: student.id,
      name: studentDetail.name,
      children: [
        ListTile(
          leading: Icon(Icons.book),
          title: Text("All Books"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ShowAllBooksPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text("Change Password"),
        ),
        Divider(
          indent: 16,
          endIndent: 16,
        ),
        ListTile(
          leading: Icon(Icons.power_settings_new),
          title: Text("Logout"),
          onTap: () async {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
              await userProvider.logOut();
            });
          },
        )
      ],
    );

    Widget bookTile({
      @required String title,
      @required String author,
      @required String publisher,
      @required bool isAvailable,
    }) {
      return ListTile(
        title: Text("$title"),
        subtitle: Text("by $author \npublished by $publisher"),
        trailing: Text(
          isAvailable ? "Available" : "Unavailable",
        ),
      );
    }

    return Material(
      child: Scaffold(
        drawer: drawer,
        appBar: AppBar(
          title: Text(
            "Borrowed Books",
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return SearchBookPage();
              },
            ));
          },
          label: Text("Find Books"),
        ),
        body: SafeArea(
          child: Container(),
        ),
      ),
    );
  }
}
