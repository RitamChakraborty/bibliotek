import 'package:bibliotek/widgets/custom_button.dart';
import 'package:bibliotek/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reenteredNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: "New Password",
                    controller: _currentPasswordController,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: "Reenter New Password",
                    controller: _currentPasswordController,
                  ),
                  SizedBox(height: 32),
                  CustomButton(
                    onPressed: () {
                      String currentPassword = _currentPasswordController.text;
                      String newPassword = _newPasswordController.text;
                      String reenteredNewPassword =
                          _reenteredNewPasswordController.text;
                    },
                    label: "Change",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
