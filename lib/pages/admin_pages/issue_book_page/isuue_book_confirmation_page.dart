import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IssueBookConfirmationPage extends StatelessWidget {
  final User _student;
  final Book _book;
  final Timestamp _timestamp;

  const IssueBookConfirmationPage({
    @required User student,
    Book book,
    Timestamp timestamp,
  })  : this._student = student,
        this._book = book,
        this._timestamp = timestamp,
        assert(student != null),
        assert(book != null),
        assert(timestamp != null);

  @override
  Widget build(BuildContext context) {
    Widget labelText(String text) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "$text",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Todo: fix
                            labelText("Student"),
//                            labelText("    ID: ${_student.id}"),
//                            labelText("    Name: ${_student.name}"),
                            labelText("Book"),
//                            labelText("    Title: ${_book.bookName}"),
//                            labelText("    Author: ${_book.authorName}"),
                            labelText("Information"),
                            labelText(
                                "    Issue Date: ${DATE_FORMAT.format(_timestamp.toDate())}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomButton(
                      onPressed: () {},
                      label: "Confirm",
                    ),
                    CustomButton(
                      label: "Edit",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
