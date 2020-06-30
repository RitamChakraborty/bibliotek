import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:meta/meta.dart';

class LocalStorageProvider {
  final SharedPreferencesService _sharedPreferencesService;

  const LocalStorageProvider(
      {@required SharedPreferencesService sharedPreferencesService})
      : this._sharedPreferencesService = sharedPreferencesService,
        assert(sharedPreferencesService != null);

  Future<Map<String, dynamic>> getData() => _sharedPreferencesService.getData();

  Future<bool> setData({@required String userRef}) =>
      _sharedPreferencesService.setData(userRef: userRef);

  Future<void> clearUser() => _sharedPreferencesService.clearUser();
}
