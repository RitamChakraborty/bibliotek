import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';

abstract class AbstractSharedPreferencesServicesEvent {}

class SharedPreferencesServicesSetUserEvent
    extends AbstractSharedPreferencesServicesEvent {
  final User _user;

  SharedPreferencesServicesSetUserEvent({@required User user})
      : this._user = user,
        assert(user != null);

  User get user => _user;
}

class SharedPreferencesServicesGetUserEvent
    extends AbstractSharedPreferencesServicesEvent {}
