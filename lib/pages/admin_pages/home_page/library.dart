import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Library extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Library"),
        ),
        body: SafeArea(
          child: StreamBuilder<List<Subject>>(
            stream: _firestoreServices.getSubjects(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Subject> subjects = snapshot.data;

                if (subjects.isNotEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: subjects.length,
                    itemBuilder: (BuildContext context, int index) {
                      Subject subject = subjects[index];

                      return ExpansionTile(
                        title: Text(subject.subject),
                        children: subject.books.map((dynamic bookRef) {
                          return StreamBuilder<Book>(
                            stream: _firestoreServices.getBookByRefId(
                                refId: bookRef),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Book book = snapshot.data;
                                return BookCard(book: book);
                              }

                              return Text("Loading");
                            },
                          );
                        }).toList(),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  );
                }

                return Center(
                  child: Text("Library is empty"),
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
