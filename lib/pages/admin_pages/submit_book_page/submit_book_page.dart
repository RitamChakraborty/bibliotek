import 'package:bibliotek/bloc/submit_book_bloc/submit_book_bloc.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/providers/firestore_provider.dart';
import 'package:bibliotek/widgets/issued_book_card.dart';
import 'package:bibliotek/widgets/loading_issued_book.dart';
import 'package:bibliotek/widgets/search_field.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SubmitBookPage extends StatefulWidget {
  @override
  _SubmitBookPageState createState() => _SubmitBookPageState();
}

class _SubmitBookPageState extends State<SubmitBookPage> {
  FireStoreProvider firestore;
  SubmitBookBloc submitBookBloc;
  String filter = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    submitBookBloc = BlocProvider.of<SubmitBookBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    firestore = Provider.of<FireStoreProvider>(context);

    return Material(
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            title: SearchField(
              controller: _controller,
              onChanged: (String value) {
                setState(() {
                  filter = value;
                });
              },
            ),
            actions: [
              filter.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          filter = "";
                          _controller.text = "";
                        });
                      },
                      icon: Icon(Icons.clear),
                    )
                  : Container(),
            ],
          ),
          body: SafeArea(
            child: BlocConsumer<SubmitBookBloc, AbstractSubmitBookState>(
                bloc: submitBookBloc,
                builder: (BuildContext context,
                    AbstractSubmitBookState submitBookState) {
                  return StreamBuilder<List<IssuedBook>>(
                    stream: firestore.getIssuedBooks(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<IssuedBook> issuedBooks = snapshot.data;
                        List<dynamic> issuedBookRefs =
                            issuedBooks.map((e) => e.refId).toList();

                        return StreamBuilder(
                          stream: firestore.getStudentsWithPendingBooks(
                              issuedBookRefs: issuedBookRefs),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<User> users = snapshot.data;

                              if (users.isNotEmpty) {
                                List<User> filteredUsers = users
                                    .where((element) =>
                                        element.id.startsWith(filter))
                                    .toList();

                                return ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  itemCount: filteredUsers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    User student = filteredUsers[index];

                                    return Card(
                                      child: Wrap(
                                        children: [
                                          ValueTile(
                                              label: "ID", value: student.id),
                                          ValueTile(
                                              label: "Name",
                                              value: student.name),
                                          ExpansionTile(
                                            title: Text("Issued Books"),
                                            children: student.issuedBooks
                                                .map((dynamic issuedBookRef) {
                                              return FutureBuilder<
                                                  Map<String, dynamic>>(
                                                future: firestore
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

                                                    return ListTile(
                                                      title: IssuedBookCard(
                                                        book: book,
                                                        issuedBook: issuedBook,
                                                      ),
                                                      trailing: IconButton(
                                                        icon: Icon(Icons
                                                            .assignment_turned_in),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Are you sure?"),
                                                                content: Wrap(
                                                                  children: [
                                                                    ExpansionTile(
                                                                      title: Text(
                                                                          "Book"),
                                                                      initiallyExpanded:
                                                                          true,
                                                                      children: [
                                                                        ValueTile(
                                                                            label:
                                                                                "Title",
                                                                            value:
                                                                                book.title),
                                                                        ValueTile(
                                                                            label:
                                                                                "Author",
                                                                            value:
                                                                                book.author),
                                                                      ],
                                                                    ),
                                                                    ExpansionTile(
                                                                      title: Text(
                                                                          "Student"),
                                                                      initiallyExpanded:
                                                                          true,
                                                                      children: [
                                                                        ValueTile(
                                                                          label:
                                                                              "ID",
                                                                          value:
                                                                              student.id,
                                                                        ),
                                                                        ValueTile(
                                                                            label:
                                                                                "Name",
                                                                            value:
                                                                                student.name),
                                                                      ],
                                                                    ),
                                                                    ValueTile(
                                                                      label:
                                                                          "Issue Date",
                                                                      value: DATE_FORMAT
                                                                          .format(
                                                                              issuedBook.issuedOn),
                                                                    ),
                                                                    ValueTile(
                                                                      label:
                                                                          "Due Date",
                                                                      value: DATE_FORMAT
                                                                          .format(
                                                                              issuedBook.dueDate),
                                                                    ),
                                                                    ValueTile(
                                                                      label:
                                                                          "Today",
                                                                      value: DATE_FORMAT
                                                                          .format(
                                                                              DateTime.now()),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      submitBookBloc.add(SubmitBookEvent(
                                                                          issuedBook:
                                                                              issuedBook));
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Yes"),
                                                                  ),
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Cancel"),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
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
                            }

                            return Center(child: CircularProgressIndicator());
                          },
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  );
                },
                listener: (BuildContext context,
                    AbstractSubmitBookState submitBookState) {
                  if (submitBookState is SubmitBookLoadingState) {
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("Processing..."),
                      ));
                  } else if (submitBookState is SubmitBookSuccessState) {
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("Book submitted successfully."),
                      ));
                    submitBookBloc.add(SubmitBookInvokeInitialEvent());
                  }
                }),
          ),
        );
      }),
    );
  }
}
