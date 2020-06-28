import 'package:bibliotek/bloc/books_bloc/book_bloc_events/book_bloc_event.dart';
import 'package:bibliotek/bloc/books_bloc/book_bloc_states/book_bloc_state.dart';
import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBooksPage extends StatefulWidget {
  @override
  _AddBooksPageState createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  BookBloc bookBloc;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController copiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookBloc = BlocProvider.of<BookBloc>(context);
    bookBloc.add(BookBlocInvokeInitialEvent());
  }

  @override
  void dispose() {
    super.dispose();
    bookBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, AbstractBookBlocState>(
      bloc: bookBloc,
      builder: (BuildContext context, AbstractBookBlocState bookBlocState) {
        // Get the values from the state
        String title = bookBlocState.title;
        String author = bookBlocState.author;
        String subject = bookBlocState.subject;
        int copies = bookBlocState.copies;

        // Set the values for the controller
        titleController.text = title;
        authorController.text = author;
        copiesController.text = copies.toString();

        if (bookBlocState is BookExistsState) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Book already exists"),
                  content: Text(
                      "Do you want to increase the number of books in the Library?"),
                  actions: [
                    FlatButton(
                      onPressed: bookBlocState is BookBlocLoadingState
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: Text("Cancel"),
                    ),
                    FlatButton(
                      onPressed: bookBlocState is BookBlocLoadingState
                          ? null
                          : () {
                              bookBloc.add(BookBlocConfirmationEvent());
                            },
                      child: Text("Yes"),
                    )
                  ],
                );
              });
        } else if (bookBlocState is BookBlocAskForConfirmationState) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Do you want to add this book"),
                  content: Column(children: [
                    ValueTile(
                      label: "Title",
                      value: title,
                    ),
                    ValueTile(
                      label: "Author",
                      value: author,
                    ),
                    ValueTile(
                      label: "Subject",
                      value: subject,
                    ),
                    ValueTile(
                      label: "Number of copies",
                      value: copies.toString(),
                    ),
                  ]),
                  actions: [
                    FlatButton(
                      onPressed: bookBlocState is BookBlocLoadingState
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: Text("Cancel"),
                    ),
                    FlatButton(
                      onPressed: bookBlocState is BookBlocLoadingState
                          ? null
                          : () {
                              bookBloc.add(BookBlocConfirmationEvent());
                            },
                      child: Text("Yes"),
                    )
                  ],
                );
              });
        } else if (bookBlocState is BookBlocSuccessState) {
          Fluttertoast.showToast(msg: "Book added successfully");
        }

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
                        controller: titleController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.bookErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "Author Name",
                        controller: authorController,
                        errorText: bookBlocState is BookBlocErrorState
                            ? bookBlocState.authorErrorMessage
                            : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                                color: Theme.of(context).accentColor)),
                        child: ListTile(
                          title: Text("Subject"),
                          trailing: DropdownButton<String>(
                              value: subject,
                              onChanged: (String value) {
                                bookBloc.add(ChangeSubjectEvent(
                                  title: title,
                                  author: author,
                                  subject: value,
                                  copies: copies,
                                ));
                              },
                              items: SUBJECTS
                                  .map((String subject) =>
                                      DropdownMenuItem<String>(
                                        value: subject,
                                        child: Text(subject),
                                      ))
                                  .toList()),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        labelText: "Number of copies",
                        controller: copiesController,
                        textInputType: TextInputType.number,
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
                        onPressed: bookBlocState is BookBlocLoadingState
                            ? null
                            : () {
                                bookBloc.add(
                                  BookBlocAddBookEvent(
                                    title: titleController.text,
                                    author: authorController.text,
                                    subject: subject,
                                    copies: copiesController.text.isEmpty
                                        ? 0
                                        : int.parse(copiesController.text),
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
