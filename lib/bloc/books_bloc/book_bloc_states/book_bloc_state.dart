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
