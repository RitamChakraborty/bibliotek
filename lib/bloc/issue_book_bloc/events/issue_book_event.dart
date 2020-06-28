import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AbstractIssueBookEvent {}

class IssueBookInvokeInitialEvent extends AbstractIssueBookEvent {}

class StudentPickedEvent extends AbstractIssueBookEvent {
  final User _student;

  StudentPickedEvent({
    @required User student,
  })  : this._student = student,
        assert(student != null);

  User get student => _student;
}

class BookPickedEvent extends AbstractIssueBookEvent {
  final Book _book;

  BookPickedEvent({@required Book book})
      : this._book = book,
        assert(book != null);

  Book get book => _book;
}

class DatePickedEvent extends AbstractIssueBookEvent {
  final DateTime _dateTime;

  DatePickedEvent({@required DateTime dateTime})
      : this._dateTime = dateTime,
        assert(dateTime != null);

  Timestamp get timestamp => Timestamp.fromDate(_dateTime);
}

class CloseSelectedStudentEvent extends AbstractIssueBookEvent {}

class CloseSelectedBookEvent extends AbstractIssueBookEvent {}

class CloseSelectedDateEvent extends AbstractIssueBookEvent {}

class IssueBookEvent extends AbstractIssueBookEvent {
  final User _admin;
  final User _student;
  final Book _book;
  final Timestamp _timestamp;

  IssueBookEvent(
      {@required User admin,
      @required User student,
      @required Book book,
      @required Timestamp timestamp})
      : this._admin = admin,
        this._student = student,
        this._book = book,
        this._timestamp = timestamp,
        assert(admin != null),
        assert(student != null),
        assert(book != null),
        assert(timestamp != null);

  User get admin => _admin;

  Timestamp get timestamp => _timestamp;

  Book get book => _book;

  User get student => _student;
}
