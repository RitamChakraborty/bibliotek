import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/library.dart';
import 'package:bibliotek/pages/login_pages/change_password_page.dart';
import 'package:bibliotek/providers/firestore_provider.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/widgets/custom_drawer.dart';
import 'package:bibliotek/widgets/issued_book_card.dart';
import 'package:bibliotek/widgets/loading_issued_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FireStoreProvider firestore = Provider.of<FireStoreProvider>(context);
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
            "Issued Books",
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: StreamBuilder<User>(
            stream: firestore.getUserById(refId: student.refId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data;
                List<dynamic> issuedBooks = user.issuedBooks;

                if (issuedBooks.isNotEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: issuedBooks.length,
                    itemBuilder: (BuildContext context, int index) {
                      String issuedBookRef = issuedBooks[index];

                      return FutureBuilder<Map<String, dynamic>>(
                        future: firestore.getIssuedBookAsFutureById(
                            issuedBookRef: issuedBookRef),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> map = snapshot.data;
                            IssuedBook issuedBook = map['issued_book'];
                            Book book = map['book'];

                            return IssuedBookCard(
                              book: book,
                              issuedBook: issuedBook,
                            );
                          }

                          return LoadingIssuedBook();
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

/*
StreamBuilder<User>(
            stream: _firestoreServices.getUserById(refId: student.refId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                student = snapshot.data;
                List<dynamic> pendingBookRefs = student.issuedBooks;

                if (pendingBookRefs.isNotEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: pendingBookRefs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String issuedBookRef = pendingBookRefs[index];

                      return StreamBuilder<IssuedBook>(
                        stream: _firestoreServices.getIssuedBookById(
                            refId: issuedBookRef),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            IssuedBook issuedBook = snapshot.data;
                            String bookRef = issuedBook.book;
                            String issuedDate =
                                DATE_FORMAT.format(issuedBook.issuedOn);
                            String dueDate =
                                DATE_FORMAT.format(issuedBook.dueDate);

                            return StreamBuilder<Book>(
                              stream: _firestoreServices.getBookByRefId(
                                  refId: bookRef),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  Book book = snapshot.data;

                                  return Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Wrap(
                                        children: [
                                          ExpansionTile(
                                            title: Text("Book"),
                                            subtitle: Text(book.title),
                                            children: [
                                              ValueTile(
                                                  label: "Author",
                                                  value: book.author),
                                            ],
                                          ),
                                          ValueTile(
                                            label: "Issue Date",
                                            value: issuedDate,
                                          ),
                                          ValueTile(
                                            label: "Due Date",
                                            value: dueDate,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return loadingBook();
                              },
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
 */
