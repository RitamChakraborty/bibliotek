import 'package:meta/meta.dart';

abstract class AbstractBookBlocEvent {}

class BookBlocAddBookEvent extends AbstractBookBlocEvent {
  final String _title;
  final String _author;
  final String _subject;
  final String _publisher;
  final int _copies;

  BookBlocAddBookEvent({
    @required String title,
    @required String author,
    @required String subject,
    @required String publisher,
    @required int copies,
  })  : this._title = title,
        this._author = author,
        this._subject = subject,
        this._publisher = publisher,
        this._copies = copies,
        assert(title != null),
        assert(author != null),
        assert(subject != null),
        assert(publisher != null),
        assert(copies != null);

  int get copies => _copies;

  String get subject => _subject;

  String get author => _author;

  String get title => _title;

  String get publisher => _publisher;
}
