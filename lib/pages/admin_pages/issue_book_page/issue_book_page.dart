import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/bloc/issue_book_bloc/states/issue_book_state.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/book_picker_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/student_picker_page.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_card.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IssueBookPage extends StatefulWidget {
  @override
  _IssueBookPageState createState() => _IssueBookPageState();
}

class _IssueBookPageState extends State<IssueBookPage> {
  IssueBookBloc issueBookBloc;
  User student;
  Book book;
  Subject subject;
  Timestamp timestamp = Timestamp.now();

  @override
  void initState() {
    super.initState();
    issueBookBloc = BlocProvider.of<IssueBookBloc>(context);
    issueBookBloc.add(IssueBookInvokeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueBookBloc, AbstractIssueBookState>(
      bloc: issueBookBloc,
      builder: (BuildContext context, AbstractIssueBookState issueBookState) {
        if (issueBookState is IssueBookSuccessState) {
          Fluttertoast.showToast(msg: "Book issued successfully");

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pop(context);
          });

          student = null;
          book = null;
          subject = null;
          timestamp = null;

          issueBookBloc.add(IssueBookInvokeInitialEvent());
        }

        return Material(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Issue Book"),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (student == null) {
                  Fluttertoast.showToast(msg: "Please pick a student first");
                } else if (book == null) {
                  Fluttertoast.showToast(msg: "Please pick a book first");
                } else if (timestamp == null) {
                  Fluttertoast.showToast(msg: "Please select a date first");
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Are you sure?"),
                        content: Column(
                          children: [
                            ExpansionTile(
                              title: Text("Book"),
                              initiallyExpanded: true,
                              children: [
                                ValueTile(label: "Title", value: book.title),
                                ValueTile(label: "Author", value: book.author),
                                ValueTile(
                                  label: "Subject",
                                  value: subject.subject,
                                ),
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
                                ValueTile(label: "Name", value: student.name),
                              ],
                            ),
                            ValueTile(
                              label: "Due Date",
                              value: DATE_FORMAT.format(timestamp.toDate()),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                            onPressed: issueBookState is IssueBookLoadingState
                                ? null
                                : () {
                                    issueBookBloc.add(IssueBookEvent(
                                      student: student,
                                      book: book,
                                      timestamp: timestamp,
                                    ));
                                  },
                            child: Text("Yes"),
                          ),
                          FlatButton(
                            onPressed: issueBookState is IssueBookLoadingState
                                ? null
                                : () {
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
              label: Text("Next"),
            ),
            body: SafeArea(
              child: Builder(
                builder: (BuildContext context) {
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

                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomButton(
                          label: "Pick Student",
                          onPressed: () {
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
                                    title: Text("${student.id}"),
                                    subtitle: Text("Name: ${student.name}"),
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
                          onPressed: () {
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
                                        issueBookBloc
                                            .add(CloseSelectedBookEvent());
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                        ),
                        CustomButton(
                          label: "Pick Date",
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2016),
                              initialDate: DateTime.now(),
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
                                        issueBookBloc
                                            .add(CloseSelectedDateEvent());
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
