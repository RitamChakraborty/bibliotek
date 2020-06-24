import 'package:bibliotek/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/providers/user_provider.dart';
import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordPage extends StatefulWidget {
  final UserProvider userProvider;

  const ChangePasswordPage(this.userProvider);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ChangePasswordBloc changePasswordBloc;
  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _reenteredNewPasswordController =
      TextEditingController();

  @override
  void initState() {
    changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    changePasswordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = widget.userProvider;
    User user = userProvider.user;

    return BlocBuilder<ChangePasswordBloc, AbstractChangePasswordState>(
      bloc: changePasswordBloc,
      builder: (BuildContext context,
          AbstractChangePasswordState changePasswordState) {
        if (changePasswordState is ChangePasswordSuccessState) {
          Fluttertoast.showToast(msg: "Password changed successfully");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            await userProvider.logOut();
            Navigator.pop(context);
          });
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
                            ? changePasswordState.currentPasswordErrorMessage
                            : null,
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        labelText: "New Password",
                        controller: _newPasswordController,
                        isPassword: true,
                        errorText:
                            changePasswordState is ChangePasswordErrorState
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
                            ? changePasswordState.reenteredPasswordErrorMessage
                            : null,
                      ),
                      SizedBox(height: 32),
                      CustomButton(
                        onPressed:
                            changePasswordState is ChangePasswordLoadingState
                                ? null
                                : () {
                                    String currentPassword =
                                        _currentPasswordController.text;
                                    String newPassword =
                                        _newPasswordController.text;
                                    String reenteredNewPassword =
                                        _reenteredNewPasswordController.text;

                                    changePasswordBloc.add(ChangePasswordEvent(
                                      user: user,
                                      currentPassword: currentPassword,
                                      newPassword: newPassword,
                                      reenteredPassword: reenteredNewPassword,
                                    ));
                                  },
                        label: changePasswordState is ChangePasswordLoadingState
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
  }
}
