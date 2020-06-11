import 'package:flutter/material.dart';

class SubmitBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Submit Book"),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
