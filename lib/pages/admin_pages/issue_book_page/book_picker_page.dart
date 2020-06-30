import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/providers/firestore_provider.dart';
import 'package:bibliotek/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BookPickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FireStoreProvider firestore = Provider.of<FireStoreProvider>(context);
    IssueBookBloc issueBookBloc = BlocProvider.of<IssueBookBloc>(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Library"),
        ),
        body: SafeArea(
          child: StreamBuilder<List<Subject>>(
            stream: firestore.getSubjects(),
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
                            stream: firestore.getBookByRefId(refId: bookRef),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Book book = snapshot.data;
                                book.refId = bookRef;

                                return MaterialButton(
                                  onPressed: () {
                                    issueBookBloc.add(BookPickedEvent(
                                      book: book,
                                    ));
                                    Navigator.pop(context);
                                  },
                                  child: BookCard(
                                    book: book,
                                    showCopies: false,
                                  ),
                                );
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
