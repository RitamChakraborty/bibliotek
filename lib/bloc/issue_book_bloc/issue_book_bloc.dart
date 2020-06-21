import 'package:bibliotek/bloc/issue_book_bloc/events/issue_book_event.dart';
import 'package:bibliotek/bloc/issue_book_bloc/states/issue_book_state.dart';
import 'package:bloc/bloc.dart';

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
    } else if (event is CloseSelectedStudentEvent) {
      yield CloseSelectedStudentState();
    } else if (event is CloseSelectedBookEvent) {
      yield CloseSelectedBookState();
    } else if (event is CloseSelectedDateEvent) {
      yield CloseSelectedDateState();
    }
  }
}
