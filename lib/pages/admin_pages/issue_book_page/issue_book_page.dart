import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/issue_book_bloc.dart';
import 'package:bibliotek/bloc/issue_book_bloc/states/issue_book_state.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/book_picker_page.dart';
import 'package:bibliotek/pages/admin_pages/issue_book_page/student_picker_page.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IssueBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    IssueBookBloc issueBookBloc = BlocProvider.of<IssueBookBloc>(context);
    User student;
    StudentDetail studentDetail;
    Book book;
    Timestamp timestamp = Timestamp.now();

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
                    title: Text("Confirm"),
                    content: Text(
                        "Book\n\t\tTitle: ${book.title}\n\t\tAuthor: ${book.author}\n\nStudent\n\t\tID: ${student.id}\n\t\tName: ${studentDetail.name}\n\nDate: ${DATE_FORMAT.format(timestamp.toDate())}"),
                    actions: [
                      FlatButton(
                        onPressed: () {},
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
          label: Text("Next"),
        ),
        body: SafeArea(
          child: BlocBuilder<IssueBookBloc, AbstractIssueBookState>(
            bloc: issueBookBloc,
            builder:
                (BuildContext context, AbstractIssueBookState issueBookState) {
              if (issueBookState is StudentPickedState) {
                student = issueBookState.student;
                studentDetail = issueBookState.studentDetail;
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
                                title: Text("ID: ${student.id}"),
                                subtitle: Text("Name: ${studentDetail.name}"),
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
                                    issueBookBloc.add(CloseSelectedBookEvent());
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
                            issueBookBloc.add(DatePickedEvent(dateTime: value));
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
