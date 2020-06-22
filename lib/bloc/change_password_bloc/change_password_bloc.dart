import 'package:bibliotek/utils/Sha256.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class AbstractChangePasswordEvent {}

class ChangePasswordEvent extends AbstractChangePasswordEvent {
  final String _originalPassword;
  final String _currentPassword;
  final String _newPassword;
  final String _reenteredPassword;

  ChangePasswordEvent({
    @required String originalPassword,
    @required String currentPassword,
    @required String newPassword,
    @required String reenteredPassword,
  })  : this._originalPassword = originalPassword,
        this._currentPassword = currentPassword,
        this._newPassword = newPassword,
        this._reenteredPassword = reenteredPassword,
        assert(originalPassword != null),
        assert(currentPassword != null),
        assert(newPassword != null),
        assert(reenteredPassword != null);

  String get reenteredPassword => _reenteredPassword;

  String get newPassword => _newPassword;

  String get currentPassword => _currentPassword;

  String get originalPassword => _originalPassword;
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
  @override
  AbstractChangePasswordState get initialState => ChangePasswordInitialState();

  @override
  Stream<AbstractChangePasswordState> mapEventToState(
      AbstractChangePasswordEvent event) async* {
    if (event is ChangePasswordEvent) {
      String originalPassword =
          Sha256().convert(string: event.originalPassword);
      String currentPassword = Sha256().convert(string: event.currentPassword);
      String newPassword = event.newPassword;
      String reenteredNewPassword = event.newPassword;

      if (originalPassword.isEmpty ||
          currentPassword.isEmpty ||
          newPassword.isEmpty ||
          reenteredNewPassword.isEmpty) {
        ChangePasswordErrorState(
          currentPasswordErrorMessage: currentPassword.isEmpty
              ? "Current Password can not be empty"
              : null,
          newPasswordErrorMessage:
              newPassword.isEmpty ? "New Password can not be empty" : null,
          reenteredPasswordErrorMessage: reenteredNewPassword.isEmpty
              ? "Reentered Password can not be empty"
              : null,
        );
      } else if (originalPassword != currentPassword) {
        ChangePasswordErrorState(
            currentPasswordErrorMessage: "Current Password did not match");
      } else if (newPassword != reenteredNewPassword) {
        ChangePasswordErrorState(
          reenteredPasswordErrorMessage:
              "Reentered Password did not match with New Password",
        );
      } else {
        yield ChangePasswordLoadingState();

        // Todo: Add firebase function

        yield ChangePasswordSuccessState();
      }
    }
  }
}
