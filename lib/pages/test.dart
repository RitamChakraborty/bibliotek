import 'package:bibliotek/bloc/shared_preferences_services_bloc/events/shared_perferences_services_events.dart';
import 'package:bibliotek/bloc/shared_preferences_services_bloc/shared_preferences_services_bloc.dart';
import 'package:bibliotek/bloc/shared_preferences_services_bloc/states/shared_peferences_services_states.dart';
import 'package:bibliotek/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SharedPreferencesServicesBloc sharedPreferencesServicesBloc =
        BlocProvider.of<SharedPreferencesServicesBloc>(context);

    return Material(
      child: Center(
        child: BlocBuilder<SharedPreferencesServicesBloc,
            AbstractSharedPreferencesServicesState>(
          bloc: sharedPreferencesServicesBloc,
          builder: (BuildContext context,
              AbstractSharedPreferencesServicesState
                  sharedPreferencesServicesState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (BuildContext context) {
                    if (sharedPreferencesServicesState
                        is SharedPreferencesServicesInitialState) {
                      return Text("Initial State");
                    } else if (sharedPreferencesServicesState
                        is SharedPreferencesServicesLoadingState) {
                      return Text("Loading");
                    } else if (sharedPreferencesServicesState
                        is SharedPreferencesServicesUserUnavailableState) {
                      return Text("User Unavailable");
                    } else if (sharedPreferencesServicesState
                        is SharedPreferencesServicesUserAvailableState) {
                      return Text(
                          "${sharedPreferencesServicesState.user.toRawJson()}");
                    }

                    return Container();
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    sharedPreferencesServicesBloc
                        .add(SharedPreferencesServicesGetUserEvent());
                  },
                  child: Text("Get User"),
                ),
                RaisedButton(
                  onPressed: () {
                    sharedPreferencesServicesBloc.add(
                      SharedPreferencesServicesSetUserEvent(
                        user: User(
                          id: "1001",
                          password: "admin",
                          name: "Librarian",
                          isAdmin: true,
                          details: {},
                        ),
                      ),
                    );
                  },
                  child: Text("Set User"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
