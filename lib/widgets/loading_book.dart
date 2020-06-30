import 'package:flutter/material.dart';

class LoadingBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          children: [
            ListTile(
              title: Text("Title"),
              trailing: Container(
                height: 16,
                width: 64,
                margin: EdgeInsets.only(top: 8),
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
            ListTile(
              title: Text("Number of copies"),
              trailing: Container(
                height: 16,
                width: 32,
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
