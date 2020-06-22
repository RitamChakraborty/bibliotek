abstract class AbstractBookBlocState {}

class BookBlocInitialState extends AbstractBookBlocState {}

class BookBlocLoadingState extends AbstractBookBlocState {}

class BookBlocErrorState extends AbstractBookBlocState {
  String bookErrorMessage;
  String authorErrorMessage;
  String subjectErrorMessage;
  String publisherErrorMessage;
  String copiesErrorMessage;

  BookBlocErrorState({
    this.bookErrorMessage,
    this.authorErrorMessage,
    this.subjectErrorMessage,
    this.publisherErrorMessage,
    this.copiesErrorMessage,
  });
}

class BookAddedState extends AbstractBookBlocState {}
