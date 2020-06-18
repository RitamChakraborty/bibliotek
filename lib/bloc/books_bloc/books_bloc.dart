import 'package:bibliotek/bloc/books_bloc/book_bloc_events/book_bloc_event.dart';
import 'package:bibliotek/bloc/books_bloc/book_bloc_states/book_bloc_state.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';

class BookBloc extends Bloc<AbstractBookBlocEvent, AbstractBookBlocState> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractBookBlocState get initialState => BookBlocInitialState();

  @override
  Stream<AbstractBookBlocState> mapEventToState(
      AbstractBookBlocEvent event) async* {
    if (event is BookBlocAddBookEvent) {
      String bookName = event.bookName;
      String authorName = event.authorName;
      String subjectName = event.subjectName;
      int numberOfCopies = event.numberOfCopies;

      if (bookName.isEmpty ||
          authorName.isEmpty ||
          subjectName.isEmpty ||
          numberOfCopies < 1) {
        yield BookBlocErrorState(
          bookNameErrorMessage:
              bookName.isEmpty ? "Book name can not be empty" : null,
          authorNameErrorMessage:
              authorName.isEmpty ? "Author's name can not be empty" : null,
          subjectNameErrorMessage:
              subjectName.isEmpty ? "Suject can not be empty" : null,
          numberOfCopiesErrorMessage: numberOfCopies < 1
              ? "Number of copies has to be greater an 1"
              : null,
        );
      } else {
        Book book = Book(
          bookName: bookName,
          authorName: authorName,
          subjectName: subjectName,
        );

        yield BookBlocLoadingState();

        await _firestoreServices.addBook(
            book: book, numberOfCopies: numberOfCopies);

        yield BookBlocInitialState();
      }
    }
  }
}
