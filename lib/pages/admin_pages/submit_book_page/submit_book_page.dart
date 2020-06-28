import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubmitBookPage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Submit Book"),
        ),
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: _firestoreServices.getPendingUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data;

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    User student = users[index];
                    S

                    List<Widget> issuedBooks = studentDetail.issuedBooks
                        .map(
                          (e) => StreamBuilder<DocumentSnapshot>(
                            stream: _firestoreServices.getBook(refId: e),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Book book = Book.fromJson(snapshot.data.data);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: ListTile(
                                        title: Text("${book.title}"),
                                        subtitle: Text("by ${book.author}"),
                                        trailing: IconButton(
                                          icon: Icon(Icons.assignment_returned),
                                          onPressed: () async {
                                            String id = student.id;
                                            String bookRef = e;

                                            await _firestoreServices.submitBook(
                                              id: id,
                                              bookRef: bookRef,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListTile(title: Text("Loading"));
                            },
                          ),
                        )
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                  title: Text("ID: ${student.id}"),
                                  subtitle:
                                      Text("Name: ${studentDetail.name}")),
                              ExpansionTile(
                                title: Text("Borrowed books"),
                                children: issuedBooks,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
