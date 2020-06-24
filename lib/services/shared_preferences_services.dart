import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _sharedPreference = SharedPreferences.getInstance();

  Future<bool> setUser({@required User user}) async {
    return (await _sharedPreference).setString('user', user.toRawJson());
  }

  Future<Map<String, dynamic>> getUser() async {
    String userString = (await _sharedPreference).getString('user');
    await Future.delayed(Duration(seconds: 2));

    if (userString == null || userString.isEmpty) {
      return {
        'user': null,
      };
    }

    return {
      'user': User.fromJsonString(userString),
    };
  }

  Future<String> getUserString() async {
    return (await _sharedPreference).getString('user');
  }

  Future<void> clearUser() async {
    return (await _sharedPreference).remove('user');
  }
}
