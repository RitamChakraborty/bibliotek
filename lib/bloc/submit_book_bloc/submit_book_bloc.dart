import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class AbstractSubmitBookEvent {}

class SubmitBookInvokeInitialEvent extends AbstractSubmitBookEvent {}

class SubmitBookEvent extends AbstractSubmitBookEvent {
  final IssuedBook _issuedBook;

  SubmitBookEvent({@required IssuedBook issuedBook})
      : this._issuedBook = issuedBook,
        assert(issuedBook != null);

  IssuedBook get issuedBook => _issuedBook;
}

class AbstractSubmitBookState {}

class SubmitBookInitialState extends AbstractSubmitBookState {}

class SubmitBookLoadingState extends AbstractSubmitBookState {}

class SubmitBookSuccessState extends AbstractSubmitBookState {}

class SubmitBookBloc
    extends Bloc<AbstractSubmitBookEvent, AbstractSubmitBookState> {
  FirestoreServices _firestoreServices = FirestoreServices();

  SubmitBookBloc() : super(SubmitBookInitialState());

  @override
  Stream<AbstractSubmitBookState> mapEventToState(
      AbstractSubmitBookEvent event) async* {
    if (event is SubmitBookInvokeInitialEvent) {
      yield SubmitBookInitialState();
    } else if (event is SubmitBookEvent) {
      IssuedBook issuedBook = event.issuedBook;
      yield SubmitBookLoadingState();

      await _firestoreServices.submitBook(issuedBook: issuedBook);

      yield SubmitBookSuccessState();
    }
  }
}
