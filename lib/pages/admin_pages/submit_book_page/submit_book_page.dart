import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SubmitBookPage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User admin = userProvider.user;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Submit Book"),
        ),
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: _firestoreServices.getStudentsWithPendingBooks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<User> students = snapshot.data;

                if (students.isNotEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: students.length,
                    itemBuilder: (BuildContext context, int index) {
                      User student = students[index];

                      return ExpansionTile(
                        title: Text(student.id),
                        subtitle: Text(student.name),
                        children: student.issuedBooks
                            .map((String bookRef) => StreamBuilder<Book>(
                                  stream: _firestoreServices.getBookByRefId(
                                      refId: bookRef),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      Book book = snapshot.data;

                                      return MaterialButton(
                                        onPressed: () async {
                                          await _firestoreServices.submitBook(
                                              adminRef: admin.refId,
                                              studentRef: student.refId,
                                              bookRef: bookRef);
                                        },
                                        child: BookCard(
                                          book: book,
                                          showCopies: false,
                                        ),
                                      );
                                    }

                                    return Text("Loading...");
                                  },
                                ))
                            .toList(),
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
