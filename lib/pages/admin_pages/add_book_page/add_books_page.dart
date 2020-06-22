import 'package:bibliotek/bloc/books_bloc/book_bloc_events/book_bloc_event.dart';
import 'package:bibliotek/bloc/books_bloc/book_bloc_states/book_bloc_state.dart';
import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBooksPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _copiesController = TextEditingController();

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
                        labelText: "Book Name",
                        controller: _titleController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.bookErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "Author Name",
                        controller: _authorController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.authorErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "Subject",
                        controller: _subjectController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.subjectErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "Publisher",
                        controller: _publisherController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.publisherErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "Number of copies",
                        controller: _copiesController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.copiesErrorMessage
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
                              title: _titleController.text,
                              author: _authorController.text,
                              subject: _subjectController.text,
                              copies: _copiesController.text.isEmpty
                                  ? 0
                                  : int.parse(_copiesController.text),
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
