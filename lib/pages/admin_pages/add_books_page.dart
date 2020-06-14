import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddBooksPage extends StatelessWidget {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _numberOfCopiesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Books"),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    labelText: "book name",
                    controller: _bookNameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    labelText: "author name",
                    controller: _authorNameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    labelText: "subject",
                    controller: _subjectNameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    labelText: "number of copies",
                    controller: _numberOfCopiesController,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  CustomButton(
                    label: "Add",
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
