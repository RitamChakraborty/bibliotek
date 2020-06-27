abstract class AbstractChangePasswordEvent {}

class ChangePasswordInvokeInitial extends AbstractChangePasswordEvent {}

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
