import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _sharedPreference = SharedPreferences.getInstance();

  Future<bool> setUser({@required User user}) async {
    return (await _sharedPreference).setString('user', user.toRawJson());
  }

  Future<String> getUser() async {
    return (await _sharedPreference).getString('user');
  }

  Future<void> clearUser() async {
    return (await _sharedPreference).remove('user');
  }
}
