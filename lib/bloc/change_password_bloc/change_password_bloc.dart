import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/utils/Sha256.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class AbstractChangePasswordEvent {}

class ChangePasswordEvent extends AbstractChangePasswordEvent {
  final User _user;
  final String _currentPassword;
  final String _newPassword;
  final String _reenteredPassword;

  ChangePasswordEvent({
    @required User user,
    @required String currentPassword,
    @required String newPassword,
    @required String reenteredPassword,
  })  : this._user = user,
        this._currentPassword = currentPassword,
        this._newPassword = newPassword,
        this._reenteredPassword = reenteredPassword,
        assert(user != null),
        assert(currentPassword != null),
        assert(newPassword != null),
        assert(reenteredPassword != null);

  String get reenteredPassword => _reenteredPassword;

  String get newPassword => _newPassword;

  String get currentPassword => _currentPassword;

  User get user => _user;
}

abstract class AbstractChangePasswordState {}

class ChangePasswordInitialState extends AbstractChangePasswordState {}

class ChangePasswordLoadingState extends AbstractChangePasswordState {}

class ChangePasswordErrorState extends AbstractChangePasswordState {
  String _currentPasswordErrorMessage;
  String _newPasswordErrorMessage;
  String _reenteredPasswordErrorMessage;

  ChangePasswordErrorState({
    String currentPasswordErrorMessage,
    String newPasswordErrorMessage,
    String reenteredPasswordErrorMessage,
  })  : this._currentPasswordErrorMessage = currentPasswordErrorMessage,
        this._newPasswordErrorMessage = newPasswordErrorMessage,
        this._reenteredPasswordErrorMessage = reenteredPasswordErrorMessage;

  String get reenteredPasswordErrorMessage => _reenteredPasswordErrorMessage;

  String get newPasswordErrorMessage => _newPasswordErrorMessage;

  String get currentPasswordErrorMessage => _currentPasswordErrorMessage;
}

class ChangePasswordSuccessState extends AbstractChangePasswordState {}

class ChangePasswordBloc
    extends Bloc<AbstractChangePasswordEvent, AbstractChangePasswordState> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractChangePasswordState get initialState => ChangePasswordInitialState();

  @override
  Stream<AbstractChangePasswordState> mapEventToState(
      AbstractChangePasswordEvent event) async* {
    if (event is ChangePasswordEvent) {
      User user = event.user;
      String currentPassword = event.currentPassword;
      String newPassword = event.newPassword;
      String reenteredNewPassword = event.reenteredPassword;
      String originalPassword = user.password;
      String currentPasswordHash =
          Sha256().convert(string: event.currentPassword);

      if (currentPassword.isEmpty ||
          newPassword.isEmpty ||
          reenteredNewPassword.isEmpty) {
        yield ChangePasswordErrorState(
          currentPasswordErrorMessage: currentPassword.isEmpty
              ? "Current Password can not be empty"
              : null,
          newPasswordErrorMessage:
              newPassword.isEmpty ? "New Password can not be empty" : null,
          reenteredPasswordErrorMessage: reenteredNewPassword.isEmpty
              ? "Reentered Password can not be empty"
              : null,
        );
      } else if (originalPassword != currentPasswordHash) {
        yield ChangePasswordErrorState(
            currentPasswordErrorMessage: "Current Password did not match");
      } else if (newPassword != reenteredNewPassword) {
        yield ChangePasswordErrorState(
          reenteredPasswordErrorMessage:
              "Reentered Password did not match with New Password",
        );
      } else {
        yield ChangePasswordLoadingState();

        String newPasswordHash = Sha256().convert(string: newPassword);
        await _firestoreServices.changePassword(
            user: user, password: newPasswordHash);

        yield ChangePasswordSuccessState();
      }
    }
  }
}
