import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBooksPage extends StatelessWidget {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _numberOfCopiesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    BookBloc bookBloc = BlocProvider.of<BookBloc>(context);

    return BlocBuilder<BookBloc, AbstractBookBlocState>(
      bloc: bookBloc,
      builder: (BuildContext context, AbstractBookBlocState bookBlocState) {
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
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.bookNameErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "author name",
                        controller: _authorNameController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.authorNameErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "subject",
                        controller: _subjectNameController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.subjectNameErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "number of copies",
                        controller: _numberOfCopiesController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.numberOfCopiesErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      CustomButton(
                        label: bookBloc is BookBlocLoadingState
                            ? "Loading"
                            : "Add",
                        onPressed: () {
                          bookBloc.add(
                            BookBlocAddBookEvent(
                              bookName: _bookNameController.text,
                              authorName: _authorNameController.text,
                              subjectName: _subjectNameController.text,
                              numberOfCopies: _numberOfCopiesController
                                      .text.isEmpty
                                  ? 0
                                  : int.parse(_numberOfCopiesController.text),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
