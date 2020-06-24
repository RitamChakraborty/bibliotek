import 'package:bibliotek/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/home_page/show_all_books_page.dart';
import 'package:bibliotek/pages/change_password_page.dart';
import 'package:bibliotek/pages/student_pages/search_book_page.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

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
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: _firestoreServices.getUser(user: student),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot studentDocumentSnapshot = snapshot.data[0];
                StudentDetail modifiedDetail = StudentDetail.fromJson(
                    studentDocumentSnapshot.data['detail']);
                List<dynamic> bookRefs = modifiedDetail.issuedBooks;

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bookRefs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StreamBuilder<DocumentSnapshot>(
                      stream:
                          _firestoreServices.getBook(refId: bookRefs[index]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          Book book = Book.fromJson(snapshot.data.data);

                          return ListTile(
                            title: Text("${book.title}"),
                            subtitle: Text("${book.author}"),
                          );
                        }

                        return ListTile();
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
