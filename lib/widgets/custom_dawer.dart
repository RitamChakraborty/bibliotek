import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String _name;
  final String _id;
  final List<Widget> _children;

  const CustomDrawer(
      {@required String name,
      @required String id,
      @required List<Widget> children})
      : this._name = name,
        this._id = id,
        this._children = children,
        assert(id != null),
        assert(name != null),
        assert(children != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerChildren = [
      UserAccountsDrawerHeader(
        accountName: Text("${_name}"),
        accountEmail: Text("${_id}"),
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
