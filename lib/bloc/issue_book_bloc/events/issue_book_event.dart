import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AbstractIssueBookEvent {}

class StudentPickedEvent extends AbstractIssueBookEvent {
  final User _student;

  StudentPickedEvent({@required User student})
      : this._student = student,
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
