import 'package:bibliotek/bloc/books_bloc/book_bloc_events/book_bloc_event.dart';
import 'package:bibliotek/bloc/books_bloc/book_bloc_states/book_bloc_state.dart';
import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';

class BookBloc extends Bloc<AbstractBookBlocEvent, AbstractBookBlocState> {
  final FirestoreServices _firestoreServices = FirestoreServices();
  String _title = "";
  String _author = "";
  String _subject = SUBJECTS[0];
  int _copies = 0;
  String _bookRef = "";

  BookBloc()
      : super(BookBlocInitialState(
          title: "",
          author: "",
          subject: SUBJECTS[0],
          copies: 0,
        ));

  @override
  Stream<AbstractBookBlocState> mapEventToState(
      AbstractBookBlocEvent event) async* {
    if (event is BookBlocInvokeInitialEvent) {
      // Set to default value on invoke initial event
      _title = "";
      _author = "";
      _subject = SUBJECTS[0];
      _copies = 0;
      _bookRef = "";

      yield BookBlocInitialState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );
    } else if (event is ChangeSubjectEvent) {
      _title = event.title;
      _author = event.author;
      _subject = event.subject;
      _copies = event.copies;

      yield SubjectChangedState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );
    } else if (event is BookBlocAddBookEvent) {
      _title = event.title;
      _author = event.author;
      _subject = event.subject;
      _copies = event.copies;

      if (_title.isEmpty ||
          _author.isEmpty ||
          _subject.isEmpty ||
          _copies < 1) {
        yield BookBlocErrorState(
          title: _title,
          author: _author,
          subject: _subject,
          copies: _copies,
          bookErrorMessage:
              _title.isEmpty ? "Book name can not be empty" : null,
          authorErrorMessage:
              _author.isEmpty ? "Author's name can not be empty" : null,
          copiesErrorMessage:
              _copies < 1 ? "Number of copies has to be greater an 1" : null,
        );
      } else {
        Book book = Book(title: _title, author: _author, copies: _copies);

        yield BookBlocLoadingState(
          title: _title,
          author: _author,
          subject: _subject,
          copies: _copies,
        );

        Map<String, dynamic> data =
            await _firestoreServices.getBookExistence(book: book);

        if (data['book_exists']) {
          _bookRef = data['book_ref'];
          yield BookExistsState(
            title: _title,
            author: _author,
            subject: _subject,
            copies: _copies,
          );
        } else {
          yield BookBlocAskForConfirmationState(
            title: _title,
            author: _author,
            subject: _subject,
            copies: _copies,
          );
        }
      }
    } else if (event is AddBookConfirmationEvent) {
      yield BookBlocLoadingState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );

      Book book = Book(title: _title, author: _author, copies: _copies);

      await _firestoreServices.addBook(book: book, subject: _subject);

      _title = "";
      _author = "";
      _subject = SUBJECTS[0];
      _copies = 0;
      _bookRef = "";

      yield BookBlocSuccessState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );
    } else if (event is IncreaseBookConfirmationEvent) {
      yield BookBlocLoadingState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );

      await _firestoreServices.updateBookByRefId(
          refId: _bookRef, copies: _copies);

      _title = "";
      _author = "";
      _subject = SUBJECTS[0];
      _copies = 0;
      _bookRef = "";

      yield BookBlocSuccessState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );
    }
  }
}
