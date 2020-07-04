import 'package:bibliotek/bloc/books_bloc/book_bloc_events/book_bloc_event.dart';
import 'package:bibliotek/bloc/books_bloc/book_bloc_states/book_bloc_state.dart';
import 'package:bibliotek/bloc/books_bloc/books_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  blocTest(
    "Add book test",
    build: () async => BookBloc(),
    act: (BookBloc bookBloc) async => bookBloc.add(AddBookConfirmationEvent()),
    expect: [
      BookBlocLoadingState(),
      BookBlocSuccessState(),
    ],
  );
}
