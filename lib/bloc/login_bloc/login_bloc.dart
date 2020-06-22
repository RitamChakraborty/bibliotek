import 'dart:convert';

import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<AbstractLoginEvent, AbstractLoginState> {
  SharedPreferencesService _sharedPreferenceServices =
      SharedPreferencesService();

  @override
  AbstractLoginState get initialState => LoginInitialState();

  @override
  Stream<AbstractLoginState> mapEventToState(AbstractLoginEvent event) async* {
    if (event is CheckLocalStorageEvent) {
      yield LoginLoadingState();

      String userRawJson = await _sharedPreferenceServices.getUser();

      if (userRawJson == null || userRawJson.isEmpty) {
        yield UserNotFoundState();
      } else {
        User user = User.fromJson(jsonDecode(userRawJson));
        yield LoginSuccessState(user: user);
      }
    }
//    if (event is LoginEvent) {
//      String id = event.id;
//      String password = event.password;
//
//      if (id.isEmpty && password.isEmpty) {
//        yield ErrorState(
//          idErrorMessage: "Id can not be empty",
//          passwordErrorMessage: "Password can not be empty",
//        );
//      } else if (id.isEmpty) {
//        yield ErrorState(idErrorMessage: "Id can not be empty");
//      } else if (password.isEmpty) {
//        yield ErrorState(passwordErrorMessage: "Password can not be empty");
//      } else {
//        String hashPassword = Sha256.convert(string: password);
//        Stream<List<DocumentSnapshot>> userDocumentSnapshotListStream =
//            FirestoreServices().getUserDocuments(id: event.id);
//
//        yield LoadingState();
//
//        await for (List<DocumentSnapshot> userDocumentSnapshotList
//            in userDocumentSnapshotListStream) {
//          if (userDocumentSnapshotList.isNotEmpty) {
//            bool correctPassword = false;
//            User user;
//
//            for (DocumentSnapshot userDocumentSnapshot
//                in userDocumentSnapshotList) {
//              Map<String, dynamic> data = userDocumentSnapshot.data;
//
//              if (data['password'] == hashPassword) {
//                user = User.fromJson(data);
//                correctPassword = true;
//                break;
//              }
//              break;
//            }
//
//            if (correctPassword) {
//              yield LoginSuccessState(user: user);
//            } else {
//              yield ErrorState(passwordErrorMessage: "Incorrect password");
//            }
//          } else {
//            yield ErrorState(idErrorMessage: "Id does not exits");
//          }
//
//          break;
//        }
//      }
//    } else if (event is LogoutEvent) {
//      yield InitialState();
//    }
  }
}
