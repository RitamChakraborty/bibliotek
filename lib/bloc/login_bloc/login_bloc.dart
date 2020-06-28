import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/services/shared_preferences_services.dart';
import 'package:bibliotek/utils/Sha256.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<AbstractLoginEvent, AbstractLoginState> {
  SharedPreferencesService _sharedPreferenceServices =
      SharedPreferencesService();
  FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractLoginState get initialState => LoginInitialState();

  @override
  Stream<AbstractLoginState> mapEventToState(AbstractLoginEvent event) async* {
    if (event is LoginBlocInvokeInitialEvent) {
      yield LoginInitialState();
    } else if (event is LoginEvent) {
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

        User user = await _firestoreServices.getUserFromId(id: id);

        if (user != null) {
          String passwordHash = Sha256().convert(string: password);
          String userPasswordHash = user.password;

          if (passwordHash != userPasswordHash) {
            yield LoginErrorState(
              passwordErrorMessage: "Password does not match",
            );
          }

          await _sharedPreferenceServices.setData(userRef: user.refId);

          yield LoginSuccessState(user: user);
        } else {
          yield LoginErrorState(
            idErrorMessage: "ID does not exists",
          );
        }
      }
    }
  }
}
