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
