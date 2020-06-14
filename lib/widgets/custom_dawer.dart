import 'package:bibliotek/models/user.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final User _user;
  final List<Widget> _children;

  const CustomDrawer({@required User user, @required List<Widget> children})
      : this._user = user,
        this._children = children,
        assert(user != null),
        assert(children != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerChildren = [
      UserAccountsDrawerHeader(
        accountName: Text("${_user.name}"),
        accountEmail: Text("${_user.id}"),
      ),
    ];

    drawerChildren.addAll(_children);

    return Drawer(
      elevation: 0,
      child: ListView(
        children: drawerChildren,
      ),
    );
  }
}
