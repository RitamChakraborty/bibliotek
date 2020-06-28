import 'package:bibliotek/bloc/change_password_bloc/events/change_password_event.dart';
import 'package:bibliotek/bloc/change_password_bloc/states/change_password_state.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:bibliotek/utils/Sha256.dart';
import 'package:bloc/bloc.dart';

class ChangePasswordBloc
    extends Bloc<AbstractChangePasswordEvent, AbstractChangePasswordState> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  AbstractChangePasswordState get initialState => ChangePasswordInitialState();

  @override
  Stream<AbstractChangePasswordState> mapEventToState(
      AbstractChangePasswordEvent event) async* {
    if (event is ChangePasswordInvokeInitial) {
      yield ChangePasswordInitialState();
    } else if (event is ChangePasswordEvent) {
      User user = event.user;
      String currentPassword = event.currentPassword;
      String newPassword = event.newPassword;
      String reenteredNewPassword = event.reenteredPassword;
      String originalPassword = user.password;
      String currentPasswordHash =
          Sha256().convert(string: event.currentPassword);

      if (currentPassword.isEmpty ||
          newPassword.isEmpty ||
          reenteredNewPassword.isEmpty) {
        yield ChangePasswordErrorState(
          currentPasswordErrorMessage: currentPassword.isEmpty
              ? "Current Password can not be empty"
              : null,
          newPasswordErrorMessage:
              newPassword.isEmpty ? "New Password can not be empty" : null,
          reenteredPasswordErrorMessage: reenteredNewPassword.isEmpty
              ? "Reentered Password can not be empty"
              : null,
        );
      } else if (originalPassword != currentPasswordHash) {
        yield ChangePasswordErrorState(
            currentPasswordErrorMessage: "Current Password did not match");
      } else if (currentPassword == newPassword) {
        yield ChangePasswordErrorState(
          newPasswordErrorMessage:
              "New password can not be same with current password",
        );
      } else if (newPassword.length < 8) {
        yield ChangePasswordErrorState(
          newPasswordErrorMessage: "New password has to be 8 characters long",
        );
      } else if (newPassword != reenteredNewPassword) {
        yield ChangePasswordErrorState(
          reenteredPasswordErrorMessage:
              "Reentered Password did not match with New Password",
        );
      } else {
        yield ChangePasswordLoadingState();

        String newPasswordHash = Sha256().convert(string: newPassword);

        await _firestoreServices.changePassword(
          refId: user.refId,
          newPassword: newPasswordHash,
        );

        yield ChangePasswordSuccessState();
      }
    }
  }
}
