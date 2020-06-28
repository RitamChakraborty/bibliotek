import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/library.dart';
import 'package:bibliotek/pages/change_password_page.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/widgets/book_card.dart';
import 'package:bibliotek/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User student = userProvider.user;

    Widget drawer = CustomDrawer(
      id: student.id,
      name: student.name,
      children: [
        ListTile(
          leading: Icon(Icons.book),
          title: Text("All Books"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Library(),
              ),
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
                return ChangePasswordPage();
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
        body: SafeArea(
          child: StreamBuilder<User>(
            stream:
                _firestoreServices.getUserFromReferenceId(refId: student.refId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                student = snapshot.data;
                List<dynamic> pendingBookRefs = student.issuedBooks;

                if (pendingBookRefs.isNotEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pendingBookRefs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String bookRef = pendingBookRefs[index];

                      return StreamBuilder<Book>(
                        stream:
                            _firestoreServices.getBookByRefId(refId: bookRef),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            Book book = snapshot.data;

                            return BookCard(
                              book: book,
                              showCopies: false,
                            );
                          }

                          return ListTile(
                            title: Text("Loading..."),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  );
                }

                return Center(child: Text("No pending books"));
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
