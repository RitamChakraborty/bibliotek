import 'package:bibliotek/bloc/submit_book_bloc/submit_book_bloc.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/widgets/issued_book_card.dart';
import 'package:bibliotek/widgets/loading_issued_book.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitBookPage extends StatefulWidget {
  @override
  _SubmitBookPageState createState() => _SubmitBookPageState();
}

class _SubmitBookPageState extends State<SubmitBookPage> {
  final FirestoreServices _firestoreServices = FirestoreServices();
  SubmitBookBloc submitBookBloc;

  @override
  void initState() {
    super.initState();
    submitBookBloc = BlocProvider.of<SubmitBookBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Submit Book"),
        ),
        body: SafeArea(
          child: BlocConsumer<SubmitBookBloc, AbstractSubmitBookState>(
              bloc: submitBookBloc,
              builder: (BuildContext context,
                  AbstractSubmitBookState submitBookState) {
                return StreamBuilder<List<IssuedBook>>(
                  stream: _firestoreServices.getIssuedBooks(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<IssuedBook> issuedBooks = snapshot.data;
                      List<dynamic> issuedBookRefs =
                          issuedBooks.map((e) => e.refId).toList();

                      return StreamBuilder(
                        stream: _firestoreServices.getStudentsWithPendingBooks(
                            issuedBookRefs: issuedBookRefs),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<User> users = snapshot.data;

                            return ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: users.length,
                              itemBuilder: (BuildContext context, int index) {
                                User user = users[index];

                                return Card(
                                  child: Wrap(
                                    children: [
                                      ValueTile(label: "ID", value: user.id),
                                      ValueTile(
                                          label: "Name", value: user.name),
                                      ExpansionTile(
                                        title: Text("Issued Books"),
                                        children: user.issuedBooks
                                            .map((dynamic issuedBookRef) {
                                          return FutureBuilder<
                                              Map<String, dynamic>>(
                                            future: _firestoreServices
                                                .getIssuedBookAsFutureById(
                                                    issuedBookRef:
                                                        issuedBookRef),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                Map<String, dynamic> map =
                                                    snapshot.data;
                                                IssuedBook issuedBook =
                                                    map['issued_book'];
                                                Book book = map['book'];

                                                return IssuedBookCard(
                                                  book: book,
                                                  issuedBook: issuedBook,
                                                );
                                              }

                                              return LoadingIssuedBook();
                                            },
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            );
                          }

                          return Center(
                            child: Text("No books pending"),
                          );
                        },
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                );
              },
              listener: (BuildContext context,
                  AbstractSubmitBookState submitBookState) {
                if (submitBookState is SubmitBookSuccessState) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text("Book submitted successfully."),
                    ));
                }
              }),
        ),
      ),
    );
  }
}
