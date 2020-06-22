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
      String title = event.title;
      String author = event.author;
      String subject = event.subject;
      String publisher = event.publisher;
      int copies = event.copies;

      if (title.isEmpty || author.isEmpty || subject.isEmpty || copies < 1) {
        yield BookBlocErrorState(
          bookErrorMessage: title.isEmpty ? "Book name can not be empty" : null,
          authorErrorMessage:
              author.isEmpty ? "Author's name can not be empty" : null,
          subjectErrorMessage:
              subject.isEmpty ? "Subject can not be empty" : null,
          publisherErrorMessage:
              publisher.isEmpty ? "Publisher can not be empty" : null,
          copiesErrorMessage:
              copies < 1 ? "Number of copies has to be greater an 1" : null,
        );
      } else {
        Book book = Book(
            title: title,
            author: author,
            subject: subject,
            publisher: publisher);

        yield BookBlocLoadingState();

        await _firestoreServices.addBook(
          book: book,
          copies: copies,
        );

        yield BookBlocInitialState();
      }
    }
  }
}
