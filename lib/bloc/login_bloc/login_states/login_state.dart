import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';

abstract class AbstractLoginState {}

class InitialState extends AbstractLoginState {}

class LoadingState extends AbstractLoginState {}

class ErrorState extends AbstractLoginState {
  String idErrorMessage;
  String passwordErrorMessage;

  ErrorState({this.idErrorMessage, this.passwordErrorMessage});
}

class LoginSuccessState extends AbstractLoginState {
  final User _user;

  LoginSuccessState({@required User user})
      : this._user = user,
        assert(user != null);

  User get user => _user;
}
