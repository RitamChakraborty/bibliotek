import 'dart:convert';

import 'package:bibliotek/bloc/shared_preferences_services_bloc/events/shared_perferences_services_events.dart';
import 'package:bibliotek/bloc/shared_preferences_services_bloc/states/shared_peferences_services_states.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:bloc/bloc.dart';

class SharedPreferencesServicesBloc extends Bloc<
    AbstractSharedPreferencesServicesEvent,
    AbstractSharedPreferencesServicesState> {
  SharedPreferencesService _sharedPreferencesServices =
      SharedPreferencesService();

  @override
  AbstractSharedPreferencesServicesState get initialState =>
      SharedPreferencesServicesInitialState();

  @override
  Stream<AbstractSharedPreferencesServicesState> mapEventToState(
      AbstractSharedPreferencesServicesEvent event) async* {
    if (event is SharedPreferencesServicesSetUserEvent) {
      User user = event.user;

      yield SharedPreferencesServicesLoadingState();

      await _sharedPreferencesServices.setUser(user: user);
      yield SharedPreferencesServicesInitialState();
    } else if (event is SharedPreferencesServicesGetUserEvent) {
      yield SharedPreferencesServicesLoadingState();

      String userJson = await _sharedPreferencesServices.getUserString();

      if (userJson == null) {
        yield SharedPreferencesServicesUserUnavailableState();
      } else {
        User user = User.fromJson(jsonDecode(userJson));
        yield SharedPreferencesServicesUserAvailableState(user: user);
      }
    }
  }
}
