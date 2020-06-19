import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/book_picker_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/isuue_book_confirmation_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/student_picker_page.dart';
import 'package:bibliotek/widgets/custom_button.dart';
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
  User student;
  Book book;
  Timestamp timestamp = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    IssueBookBloc issueBookBloc = BlocProvider.of<IssueBookBloc>(context);

    print(timestamp);

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
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return IssueBookConfirmationPage(
                      student: student,
                      book: book,
                      timestamp: timestamp,
                    );
                  },
                ),
              );
            }
          },
          label: Text("Next"),
        ),
        body: SafeArea(
          child: BlocBuilder<IssueBookBloc, AbstractIssueBookState>(
            bloc: issueBookBloc,
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
                          : ListTile(
                              title: Text("ID: ${student.id}"),
                              subtitle: Text("Name: ${student.name}"),
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
                          : ListTile(
                              title: Text("${book.bookName}"),
                              subtitle: Text("by ${book.authorName}"),
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
                        ).then((value) => issueBookBloc
                            .add(DatePickedEvent(dateTime: value)));
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: timestamp == null
                          ? SizedBox(
                              height: 16,
                            )
                          : ListTile(
                              title: Text("${timestamp.toDate()}"),
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
  }
}
