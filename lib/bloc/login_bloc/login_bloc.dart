import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:bibliotek/utils/Sha256.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBloc extends Bloc<AbstractLoginEvent, AbstractLoginState> {
  SharedPreferencesService _sharedPreferenceServices =
      SharedPreferencesService();
  FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractLoginState get initialState => LoginInitialState();

  @override
  Stream<AbstractLoginState> mapEventToState(AbstractLoginEvent event) async* {
    if (event is LoginEvent) {
      String id = event.id;
      String password = event.password;

      if (id.isEmpty && password.isEmpty) {
        yield LoginErrorState(
          idErrorMessage: "ID can not be empty",
          passwordErrorMessage: "Password can not be empty",
        );
      } else if (id.isEmpty) {
        yield LoginErrorState(
          idErrorMessage: "ID can not be empty",
        );
      } else if (password.isEmpty) {
        yield LoginErrorState(
          passwordErrorMessage: "Password can not be empty",
        );
      } else {
        yield LoginLoadingState();

        Stream<List<DocumentSnapshot>> userDocumentSnapshotListStream =
            _firestoreServices.getUserDocuments(id: id);

        await for (List<DocumentSnapshot> userDocumentSnapshotList
            in userDocumentSnapshotListStream) {
          if (userDocumentSnapshotList.isEmpty) {
            yield LoginErrorState(
              idErrorMessage: "ID not found",
            );
          } else {
            for (DocumentSnapshot documentSnapshot
                in userDocumentSnapshotList) {
              Map<String, dynamic> data = documentSnapshot.data;
              String passwordHash = Sha256().convert(string: password);

              if (data['password'] == passwordHash) {
                User user = User.fromJson(data);
                await _sharedPreferenceServices.setUser(user: user);
                yield LoginSuccessState(user: user);
              } else {
                yield LoginErrorState(
                  passwordErrorMessage: "Password is incorrect",
                );
              }

              break;
            }
          }

          break;
        }
      }
    }
  }
}
