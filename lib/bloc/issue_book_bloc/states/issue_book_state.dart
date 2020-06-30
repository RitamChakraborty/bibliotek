import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AbstractIssueBookState {}

class IssueBookInitialState extends AbstractIssueBookState {}

class IssueBookLoadingState extends AbstractIssueBookState {}

class StudentPickedState extends AbstractIssueBookState {
  final User _student;

  StudentPickedState({@required User student})
      : this._student = student,
        assert(student != null);

  User get student => _student;
}

class BookPickedState extends AbstractIssueBookState {
  final Book _book;

  BookPickedState({@required Book book})
      : this._book = book,
        assert(book != null);

  Book get book => _book;
}

class DatePickedState extends AbstractIssueBookState {
  final Timestamp _timestamp;

  DatePickedState({@required Timestamp timestamp})
      : this._timestamp = timestamp,
        assert(timestamp != null);

  Timestamp get timestamp => _timestamp;
}

class CloseSelectedStudentState extends AbstractIssueBookState {}

class CloseSelectedBookState extends AbstractIssueBookState {}

class CloseSelectedDateState extends AbstractIssueBookState {}

class BookAlreadyIssuedState extends AbstractIssueBookState {}

class IssueBookSuccessState extends AbstractIssueBookState {}
