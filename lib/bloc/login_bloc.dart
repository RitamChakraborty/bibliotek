import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class AbstractLoginEvent {}

class LoginEvent extends AbstractLoginEvent {
  final String _id;
  final String _password;

  LoginEvent({@required String id, @required String password})
      : this._id = id,
        this._password = password,
        assert(id != null),
        assert(password != null);

  String get password => _password;

  String get id => _id;
}

abstract class AbstractLoginState {}

class InitialState extends AbstractLoginState {}

class LoadingState extends AbstractLoginState {}

class ErrorState extends AbstractLoginState {
  String idErrorMessage;
  String passwordErrorMessage;

  ErrorState({this.idErrorMessage, this.passwordErrorMessage});
}

class LoginSuccessState extends AbstractLoginState {}

class LoginBloc extends Bloc<AbstractLoginEvent, AbstractLoginState> {
  @override
  AbstractLoginState get initialState => InitialState();

  @override
  Stream<AbstractLoginState> mapEventToState(AbstractLoginEvent event) async* {
    print('mapping');

    if (event is LoginEvent) {
      String id = event.id;
      String password = event.password;

      print('id: $id');
      print('password: $password');

      if (id.isEmpty && password.isEmpty) {
        yield ErrorState(
          idErrorMessage: "Id can not be empty",
          passwordErrorMessage: "Password can not be empty",
        );
      } else if (id.isEmpty) {
        yield ErrorState(idErrorMessage: "Id can not be empty");
      } else if (password.isEmpty) {
        yield ErrorState(passwordErrorMessage: "Password can not be empty");
      } else {
        Stream<List<DocumentSnapshot>> userDocumentSnapshotListStream =
            FirestoreServices().getUserDocuments(id: event.id);

        yield LoadingState();
        await Future.delayed(Duration(seconds: 5));

        await for (List<DocumentSnapshot> userDocumentSnapshotList
            in userDocumentSnapshotListStream) {
          if (userDocumentSnapshotList.isNotEmpty) {
            bool correctPassword = false;
            User user;

            for (DocumentSnapshot userDocumentSnapshot
                in userDocumentSnapshotList) {
              Map<String, dynamic> data = userDocumentSnapshot.data;

              if (data['password'] == password) {
                user = User.formJson(data);
                correctPassword = true;
                break;
              }
            }

            if (correctPassword) {
              yield LoginSuccessState();
            } else {
              yield ErrorState(passwordErrorMessage: "Incorrect password");
            }
          } else {
            yield ErrorState(idErrorMessage: "Id does not exits");
          }

          break;
        }
      }
    }
  }
}
