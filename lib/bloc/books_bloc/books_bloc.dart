import 'package:bibliotek/models/book.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class AbstractBookBlocEvent {}

class BookBlocAddBookEvent extends AbstractBookBlocEvent {
  final String _bookName;
  final String _authorName;
  final String _subjectName;
  final int _numberOfCopies;

  BookBlocAddBookEvent({
    @required String bookName,
    @required String authorName,
    @required String subjectName,
    @required int numberOfCopies,
  })  : this._bookName = bookName,
        this._authorName = authorName,
        this._subjectName = subjectName,
        this._numberOfCopies = numberOfCopies,
        assert(bookName != null),
        assert(authorName != null),
        assert(subjectName != null),
        assert(numberOfCopies != null);

  int get numberOfCopies => _numberOfCopies;

  String get subjectName => _subjectName;

  String get authorName => _authorName;

  String get bookName => _bookName;
}

abstract class AbstractBookBlocState {}

class BookBlocInitialState extends AbstractBookBlocState {}

class BookBlocErrorState extends AbstractBookBlocState {
  String bookNameErrorMessage;
  String authorNameErrorMessage;
  String subjectNameErrorMessage;
  String numberOfCopiesErrorMessage;

  BookBlocErrorState({
    this.bookNameErrorMessage,
    this.authorNameErrorMessage,
    this.subjectNameErrorMessage,
    this.numberOfCopiesErrorMessage,
  });
}

class BookBlocLoadingState extends AbstractBookBlocState {}

class BookBloc extends Bloc<AbstractBookBlocEvent, AbstractBookBlocState> {
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
          subject: subjectName,
        );
      }
    }
  }
}
