import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';

abstract class AbstractLoginState {}

class LoginInitialState extends AbstractLoginState {}

class LoginLoadingState extends AbstractLoginState {}

class UserNotFoundState extends AbstractLoginState {}

class LoginErrorState extends AbstractLoginState {
  String idErrorMessage;
  String passwordErrorMessage;

  LoginErrorState({this.idErrorMessage, this.passwordErrorMessage});
}

class LoginSuccessState extends AbstractLoginState {
  final User _user;

  LoginSuccessState({@required User user})
      : this._user = user,
        assert(user != null);

  User get user => _user;
}
