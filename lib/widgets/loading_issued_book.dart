import 'package:flutter/material.dart';

class LoadingIssuedBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          children: [
            ListTile(
              title: Text("Book"),
              subtitle: Container(
                height: 16,
                width: 48,
                margin: EdgeInsets.only(top: 8),
                color: Colors.grey[100],
              ),
              trailing: Icon(Icons.expand_more),
            ),
            ListTile(
              title: Text("Issue Date"),
              trailing: Container(
                height: 16,
                width: 80,
                color: Colors.grey[100],
              ),
            ),
            ListTile(
              title: Text("Issue Date"),
              trailing: Container(
                height: 16,
                width: 80,
                color: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
