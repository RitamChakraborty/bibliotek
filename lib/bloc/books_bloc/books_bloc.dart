import 'package:bibliotek/bloc/books_bloc/book_bloc_events/book_bloc_event.dart';
import 'package:bibliotek/bloc/books_bloc/book_bloc_states/book_bloc_state.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';

class BookBloc extends Bloc<AbstractBookBlocEvent, AbstractBookBlocState> {
  final FirestoreServices _firestoreServices = FirestoreServices();
  String _title = "";
  String _author = "";
  String _subject = "";
  int _copies = 0;
  String _bookRef = "";

  @override
  AbstractBookBlocState get initialState => BookBlocInitialState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );

  @override
  Stream<AbstractBookBlocState> mapEventToState(
      AbstractBookBlocEvent event) async* {
    if (event is BookBlocInvokeInitialEvent) {
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
          subjectErrorMessage:
              _subject.isEmpty ? "Subject can not be empty" : null,
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

        // Todo: First look if the book exists or not
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

        yield BookBlocSuccessState(
          title: _title,
          author: _author,
          subject: _subject,
          copies: _copies,
        );
      }
    } else if (event is BookBlocConfirmationEvent) {
      yield BookBlocLoadingState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );

      Book book = Book(title: _title, author: _author, copies: _copies);

      if (_bookRef.isNotEmpty) {
        await _firestoreServices.updateBookByRefId(refId: _bookRef, book: book);
      } else {
        await _firestoreServices.addBook(book: book, subject: _subject);
      }

      _title = "";
      _author = "";
      _subject = "";
      _copies = 0;

      yield BookBlocSuccessState(
        title: _title,
        author: _author,
        subject: _subject,
        copies: _copies,
      );
    }
  }
}
