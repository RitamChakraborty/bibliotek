import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AbstractIssueBookState {
  FirestoreServices _firestoreServices = FirestoreServices();

  Stream<List<DocumentSnapshot>> getBooks() {
    return _firestoreServices
        .getBooks()
        .map((QuerySnapshot event) => event.documents);
  }

  Stream<List<DocumentSnapshot>> getStudents() {
    return _firestoreServices
        .getStudents()
        .map((QuerySnapshot event) => event.documents);
  }
}

class IssueBookInitialState extends AbstractIssueBookState {}

class IssueBookLoadingState extends AbstractIssueBookState {}

class StudentPickedState extends AbstractIssueBookState {
  final User _student;
  final StudentDetail _studentDetail;

  StudentPickedState(
      {@required User student, @required StudentDetail studentDetail})
      : this._student = student,
        this._studentDetail = studentDetail,
        assert(student != null),
        assert(studentDetail != null);

  User get student => _student;

  StudentDetail get studentDetail => _studentDetail;
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
