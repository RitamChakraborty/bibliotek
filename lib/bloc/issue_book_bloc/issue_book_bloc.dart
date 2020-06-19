import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';
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

class IssueBookBloc
    extends Bloc<AbstractIssueBookEvent, AbstractIssueBookState> {
  @override
  AbstractIssueBookState get initialState => IssueBookInitialState();

  @override
  Stream<AbstractIssueBookState> mapEventToState(
      AbstractIssueBookEvent event) async* {
    if (event is StudentPickedEvent) {
      yield StudentPickedState(student: event.student);
    } else if (event is BookPickedEvent) {
      yield BookPickedState(book: event.book);
    } else if (event is DatePickedEvent) {
      yield DatePickedState(timestamp: event.timestamp);
    }
  }
}
