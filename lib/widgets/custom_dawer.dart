import 'package:bibliotek/models/user.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final User _user;
  final VoidCallback _logOut;

  const CustomDrawer({@required User user, @required VoidCallback logOut})
      : this._user = user,
        this._logOut = logOut,
        assert(user != null),
        assert(logOut != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${_user.name}"),
            accountEmail: Text("${_user.id}"),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change password"),
          ),
          Divider(
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text("Logout"),
            onTap: _logOut,
          )
        ],
      ),
    );
  }
}
