import 'package:bibliotek/models/user.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _sharedPreference = SharedPreferences.getInstance();

  /// Get the [User] refId from [SharedPreferences]
  /// Send the data in a map
  Future<Map<String, dynamic>> getData() async {
    return {
      'ref_id': (await _sharedPreference).getString('user_ref'),
    };
  }

  Future<bool> setData({@required String userRef}) async {
    return (await _sharedPreference).setString('user_ref', userRef);
  }

  Future<void> clearUser() async {
    return (await _sharedPreference).remove('user_ref');
  }
}
