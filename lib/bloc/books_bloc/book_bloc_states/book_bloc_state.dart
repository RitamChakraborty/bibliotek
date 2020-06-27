import 'package:meta/meta.dart';

abstract class AbstractBookBlocState {
  String _title;
  String _author;
  String _subject;
  int _copies;

  AbstractBookBlocState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : this._title = title,
        this._author = author,
        this._subject = subject,
        this._copies = copies,
        assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null);

  int get copies => _copies;

  String get subject => _subject;

  String get author => _author;

  String get title => _title;
}

class BookBlocInitialState extends AbstractBookBlocState {
  BookBlocInitialState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}

class BookBlocLoadingState extends AbstractBookBlocState {
  BookBlocLoadingState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}

class BookBlocErrorState extends AbstractBookBlocState {
  String bookErrorMessage;
  String authorErrorMessage;
  String subjectErrorMessage;
  String copiesErrorMessage;

  BookBlocErrorState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
    this.bookErrorMessage,
    this.authorErrorMessage,
    this.subjectErrorMessage,
    this.copiesErrorMessage,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}

class SubjectChangedState extends AbstractBookBlocState {
  SubjectChangedState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}

class BookBlocAskForConfirmationState extends AbstractBookBlocState {
  BookBlocAskForConfirmationState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}

class BookExistsState extends AbstractBookBlocState {
  BookExistsState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}

class BookBlocSuccessState extends AbstractBookBlocState {
  BookBlocSuccessState({
    @required String title,
    @required String author,
    @required String subject,
    @required int copies,
  })  : assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(copies != null),
        super(
          title: title,
          author: author,
          subject: subject,
          copies: copies,
        );
}
