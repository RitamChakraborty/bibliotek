import 'package:meta/meta.dart';

abstract class AbstractBookBlocEvent {}

class BookBlocInvokeInitialEvent extends AbstractBookBlocEvent {}

class ChangeSubjectEvent extends AbstractBookBlocEvent {
  final String _title;
  final String _author;
  final String _subject;
  final int _copies;

  ChangeSubjectEvent({
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

class BookBlocAddBookEvent extends AbstractBookBlocEvent {
  final String _title;
  final String _author;
  final String _subject;
  final int _copies;

  BookBlocAddBookEvent({
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

class AddBookConfirmationEvent extends AbstractBookBlocEvent {}

class IncreaseBookConfirmationEvent extends AbstractBookBlocEvent {}
