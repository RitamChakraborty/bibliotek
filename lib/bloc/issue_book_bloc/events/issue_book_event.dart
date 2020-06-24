import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AbstractIssueBookEvent {}

class StudentPickedEvent extends AbstractIssueBookEvent {
  final User _student;
  final StudentDetail _studentDetail;

  StudentPickedEvent(
      {@required User student, @required StudentDetail studentDetail})
      : this._student = student,
        this._studentDetail = studentDetail,
        assert(student != null),
        assert(studentDetail != null);

  User get student => _student;

  StudentDetail get studentDetail => _studentDetail;
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
