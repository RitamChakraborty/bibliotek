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

class ErrorIdState extends AbstractLoginState {}

class ErrorPasswordState extends AbstractLoginState {}

class LoginSuccessState extends AbstractLoginState {}

class LoginBloc extends Bloc<AbstractLoginEvent, AbstractLoginState> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractLoginState get initialState => InitialState();

  @override
  Stream<AbstractLoginState> mapEventToState(AbstractLoginEvent event) async* {
    if (event is LoginEvent) {
      String id = event.id;
      String password = event.password;

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
            print(data);
            print(password);
            if (data['password'] == password) {
              user = User.formJson(data);
              correctPassword = true;
              break;
            }
          }

          if (correctPassword) {
            yield LoginSuccessState();
          } else {
            yield ErrorPasswordState();
          }
        } else {
          yield ErrorIdState();
        }
      }
    }
  }
}
