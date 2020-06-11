import 'package:bibliotek/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IssueBookConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const student = {
      "name": "Ritam Chakraborty",
      "id": "161001001070",
      "sem": "8th",
    };

    const book = {
      "name": "Brief History",
      "author": "Stephen Hawkings",
      "issue_date": "21/03/20202",
    };
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
                            labelText("Student"),
                            labelText("    Name: ${student['name']}"),
                            labelText("    ID: ${student['id']}"),
                            labelText("    Semester: ${student['sem']}"),
                            labelText("Book"),
                            labelText("    Title: ${book['name']}"),
                            labelText("    Author: ${book['author']}"),
                            labelText("Information"),
                            labelText("    Issue Date: ${book['issue_date']}"),
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
                      label: "Confirm",
                      onPressed: () {},
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
