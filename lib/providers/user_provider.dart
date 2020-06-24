import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  User _user;
  SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  UserProvider({@required User user}) : this._user = user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  User get user => _user;

  Future<void> logOut() async {
    await _sharedPreferencesService.clearUser();
    _user = null;
    notifyListeners();
  }
}
