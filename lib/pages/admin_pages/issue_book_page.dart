import 'package:bibliotek/pages/admin_pages/book_picker_page.dart';
import 'package:bibliotek/pages/admin_pages/isuue_book_confirmation_page.dart';
import 'package:bibliotek/pages/admin_pages/student_picker_page.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IssueBookPage extends StatefulWidget {
  @override
  _IssueBookPageState createState() => _IssueBookPageState();
}

class _IssueBookPageState extends State<IssueBookPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Issue Book"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return IssueBookConfirmationPage();
                },
              ),
            );
          },
          label: Text("Next"),
        ),
        body: SafeArea(
          child: Container(
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
                SizedBox(
                  height: 16,
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
                SizedBox(
                  height: 16,
                ),
                CustomButton(
                  label: "Pick Date",
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(2016),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2021),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
