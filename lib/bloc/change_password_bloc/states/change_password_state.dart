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
