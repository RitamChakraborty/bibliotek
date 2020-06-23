import 'package:bibliotek/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_bloc.dart';
import 'package:bibliotek/bloc/login_bloc/login_events/login_event.dart';
import 'package:bibliotek/bloc/login_bloc/login_states/login_state.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reenteredNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    ChangePasswordBloc changePasswordBloc =
        BlocProvider.of<ChangePasswordBloc>(context);

    return BlocBuilder<LoginBloc, AbstractLoginState>(
      bloc: loginBloc,
      builder: (BuildContext context, AbstractLoginState loginState) {
        if (loginState is LoginSuccessState) {
          return BlocBuilder<ChangePasswordBloc, AbstractChangePasswordState>(
            bloc: changePasswordBloc,
            builder: (BuildContext context,
                AbstractChangePasswordState changePasswordState) {
              if (changePasswordState is ChangePasswordSuccessState) {
                Fluttertoast.showToast(msg: "Password changed successfully");
                loginBloc.add(LogoutEvent());
              }
              return Material(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Change Password"),
                  ),
                  body: SafeArea(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomTextField(
                              labelText: "Current Password",
                              controller: _currentPasswordController,
                              isPassword: true,
                              errorText: changePasswordState
                                      is ChangePasswordErrorState
                                  ? changePasswordState
                                      .currentPasswordErrorMessage
                                  : null,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: "New Password",
                              controller: _newPasswordController,
                              isPassword: true,
                              errorText: changePasswordState
                                      is ChangePasswordErrorState
                                  ? changePasswordState.newPasswordErrorMessage
                                  : null,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: "Reenter New Password",
                              controller: _reenteredNewPasswordController,
                              isPassword: true,
                              errorText: changePasswordState
                                      is ChangePasswordErrorState
                                  ? changePasswordState
                                      .reenteredPasswordErrorMessage
                                  : null,
                            ),
                            SizedBox(height: 32),
                            CustomButton(
                              onPressed: changePasswordState
                                      is ChangePasswordLoadingState
                                  ? null
                                  : () {
                                      String currentPassword =
                                          _currentPasswordController.text;
                                      String newPassword =
                                          _newPasswordController.text;
                                      String reenteredNewPassword =
                                          _reenteredNewPasswordController.text;

                                      changePasswordBloc
                                          .add(ChangePasswordEvent(
                                        user: loginState.user,
                                        currentPassword: currentPassword,
                                        newPassword: newPassword,
                                        reenteredPassword: reenteredNewPassword,
                                      ));
                                    },
                              label: changePasswordState
                                      is ChangePasswordLoadingState
                                  ? "Loading"
                                  : "Change",
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          Navigator.pop(context);
          return Container();
        }
      },
    );
  }
}
