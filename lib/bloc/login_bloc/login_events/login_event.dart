import 'package:meta/meta.dart';

abstract class AbstractLoginEvent {}

class LoginBlocInvokeInitialEvent extends AbstractLoginEvent {}

class LoginEvent extends AbstractLoginEvent {
  final String _id;
  final String _password;

  LoginEvent({@required String id, @required String password})
      : this._id = id,
        this._password = password,
        assert(id != null),
        assert(password != null);

  String get password => _password;

  String get id => _id;
}
