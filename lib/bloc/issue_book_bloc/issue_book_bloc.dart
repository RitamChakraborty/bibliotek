import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/states/issue_book_state.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IssueBookBloc
    extends Bloc<AbstractIssueBookEvent, AbstractIssueBookState> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractIssueBookState get initialState => IssueBookInitialState();

  @override
  Stream<AbstractIssueBookState> mapEventToState(
      AbstractIssueBookEvent event) async* {
    if (event is IssueBookInvokeInitialEvent) {
      yield IssueBookInitialState();
    } else if (event is StudentPickedEvent) {
      yield StudentPickedState(student: event.student);
    } else if (event is BookPickedEvent) {
      yield BookPickedState(book: event.book);
    } else if (event is DatePickedEvent) {
      yield DatePickedState(timestamp: event.timestamp);
    } else if (event is CloseSelectedStudentEvent) {
      yield CloseSelectedStudentState();
    } else if (event is CloseSelectedBookEvent) {
      yield CloseSelectedBookState();
    } else if (event is CloseSelectedDateEvent) {
      yield CloseSelectedDateState();
    } else if (event is IssueBookEvent) {
      User admin = event.admin;
      User student = event.student;
      Book book = event.book;
      Timestamp timestamp = event.timestamp;

      IssuedBook issuedBook = IssuedBook(
        book: book.refId,
        dueDate: timestamp.toDate(),
        issuedBy: admin.refId,
        issuedTo: student.refId,
        issuedOn: DateTime.now(),
      );

      yield IssueBookLoadingState();

      List<Book> books =
          await _firestoreServices.getBooksIssuedByStudent(student: student);
      List<dynamic> bookRefs = books.map((e) => e.refId).toList();

      if (bookRefs.contains(book.refId)) {
        yield BookAlreadyIssuedState();
      } else {
//        await _firestoreServices.issueBook(issuedBook: issuedBook);
        yield IssueBookSuccessState();
      }
    }
  }
}
