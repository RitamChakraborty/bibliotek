import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/bloc/issue_book_bloc/states/issue_book_state.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/book_picker_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/student_picker_page.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_card.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class IssueBookPage extends StatefulWidget {
  @override
  _IssueBookPageState createState() => _IssueBookPageState();
}

class _IssueBookPageState extends State<IssueBookPage> {
  IssueBookBloc issueBookBloc;
  User admin;
  User student;
  Book book;
  Timestamp timestamp = Timestamp.now();

  @override
  void initState() {
    super.initState();
    issueBookBloc = BlocProvider.of<IssueBookBloc>(context);
    issueBookBloc.add(IssueBookInvokeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    admin = userProvider.user;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Issue Book"),
        ),
        body: BlocConsumer<IssueBookBloc, AbstractIssueBookState>(
          bloc: issueBookBloc,
          listener:
              (BuildContext context, AbstractIssueBookState issueBookState) {
            if (issueBookState is IssueBookInitialState) {
              student = null;
              book = null;
              timestamp =
                  Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));
            } else if (issueBookState is IssueBookLoadingState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("Processing..."),
                ));
            } else if (issueBookState is BookAlreadyIssuedState) {
              Scaffold.of(context).hideCurrentSnackBar();

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text("This books is already issued to the student"),
                      content: Text("This please select another book"),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        )
                      ],
                    );
                  });
            } else if (issueBookState is IssueBookSuccessState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("Book issued successfully"),
                ));

              student = null;
              book = null;
              timestamp =
                  Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));

              issueBookBloc.add(IssueBookInvokeInitialEvent());
            }
          },
          builder:
              (BuildContext context, AbstractIssueBookState issueBookState) {
            if (issueBookState is StudentPickedState) {
              student = issueBookState.student;
            }
            if (issueBookState is BookPickedState) {
              book = issueBookState.book;
            }
            if (issueBookState is DatePickedState) {
              timestamp = issueBookState.timestamp;
            }
            if (issueBookState is CloseSelectedStudentState) {
              student = null;
            }
            if (issueBookState is CloseSelectedBookState) {
              book = null;
            }
            if (issueBookState is CloseSelectedDateState) {
              timestamp = null;
            }
            if (issueBookState is BookAlreadyIssuedState) {
              book = null;
            }

            return Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomButton(
                      label: "Pick Student",
                      onPressed: issueBookState is IssueBookLoadingState
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return StudentPickerPage();
                                  },
                                ),
                              );
                            },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: student == null
                          ? SizedBox(
                              height: 16,
                            )
                          : CustomCard(
                              child: ListTile(
                                title: Text("ID: ${student.id}"),
                                subtitle: Text("${student.name}"),
                                trailing: IconButton(
                                  onPressed: () {
                                    issueBookBloc
                                        .add(CloseSelectedStudentEvent());
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                            ),
                    ),
                    CustomButton(
                      label: "Pick Book",
                      onPressed: issueBookState is IssueBookLoadingState
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return BookPickerPage();
                                  },
                                ),
                              );
                            },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: book == null
                          ? SizedBox(
                              height: 16,
                            )
                          : CustomCard(
                              child: ListTile(
                                title: Text("${book.title}"),
                                subtitle: Text("by ${book.author}"),
                                trailing: IconButton(
                                  onPressed: () {
                                    issueBookBloc.add(CloseSelectedBookEvent());
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                            ),
                    ),
                    CustomButton(
                      label: "Pick Date",
                      onPressed: issueBookState is IssueBookLoadingState
                          ? null
                          : () {
                              showDatePicker(
                                context: context,
                                firstDate:
                                    DateTime.now().add(Duration(days: 1)),
                                initialDate:
                                    DateTime.now().add(Duration(days: 1)),
                                lastDate: DateTime(2021),
                              ).then((value) {
                                if (value != null) {
                                  issueBookBloc
                                      .add(DatePickedEvent(dateTime: value));
                                }
                              });
                            },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: timestamp == null
                          ? SizedBox(
                              height: 16,
                            )
                          : CustomCard(
                              child: ListTile(
                                title: Text(
                                  "${DATE_FORMAT.format(timestamp.toDate())}",
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    issueBookBloc.add(CloseSelectedDateEvent());
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                            ),
                    ),
                    CustomButton(
                      label: "Issue",
                      onPressed: issueBookState is IssueBookLoadingState
                          ? null
                          : () {
                              if (student == null) {
                                Fluttertoast.showToast(
                                    msg: "Please pick a student first");
                              } else if (book == null) {
                                Fluttertoast.showToast(
                                    msg: "Please pick a book first");
                              } else if (timestamp == null) {
                                Fluttertoast.showToast(
                                    msg: "Please select a date first");
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Are you sure?"),
                                      content: Wrap(
                                        children: [
                                          ExpansionTile(
                                            title: Text("Book"),
                                            initiallyExpanded: true,
                                            children: [
                                              ValueTile(
                                                  label: "Title",
                                                  value: book.title),
                                              ValueTile(
                                                  label: "Author",
                                                  value: book.author),
                                            ],
                                          ),
                                          ExpansionTile(
                                            title: Text("Student"),
                                            initiallyExpanded: true,
                                            children: [
                                              ValueTile(
                                                label: "ID",
                                                value: student.id,
                                              ),
                                              ValueTile(
                                                  label: "Name",
                                                  value: student.name),
                                            ],
                                          ),
                                          ValueTile(
                                            label: "Due Date",
                                            value: DATE_FORMAT
                                                .format(timestamp.toDate()),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            issueBookBloc.add(IssueBookEvent(
                                              admin: admin,
                                              student: student,
                                              book: book,
                                              timestamp: timestamp,
                                            ));

                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel"),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
