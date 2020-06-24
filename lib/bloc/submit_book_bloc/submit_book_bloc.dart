import 'package:bloc/bloc.dart';

class AbstractSubmitBookEvent {}

class SubmitBookInvokeInitialEvent extends AbstractSubmitBookEvent {}

class AbstractSubmitBookState {}

class SubmitBookInitialState extends AbstractSubmitBookState {}

class SubmitBookLoadingState extends AbstractSubmitBookState {}

class SubmitBookSuccessState extends AbstractSubmitBookState {}

class SubmitBookBloc
    extends Bloc<AbstractSubmitBookEvent, AbstractSubmitBookState> {
  @override
  AbstractSubmitBookState get initialState => SubmitBookInitialState();

  @override
  Stream<AbstractSubmitBookState> mapEventToState(
      AbstractSubmitBookEvent event) {}
}
