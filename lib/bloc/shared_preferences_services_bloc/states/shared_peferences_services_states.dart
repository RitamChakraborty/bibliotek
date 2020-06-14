import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';

abstract class AbstractSharedPreferencesServicesState {}

class SharedPreferencesServicesInitialState
    extends AbstractSharedPreferencesServicesState {}

class SharedPreferencesServicesLoadingState
    extends AbstractSharedPreferencesServicesState {}

class SharedPreferencesServicesUserUnavailableState
    extends AbstractSharedPreferencesServicesState {}

class SharedPreferencesServicesUserAvailableState
    extends AbstractSharedPreferencesServicesState {
  final User _user;

  SharedPreferencesServicesUserAvailableState({@required User user})
      : this._user = user,
        assert(user != null);

  User get user => _user;
}
