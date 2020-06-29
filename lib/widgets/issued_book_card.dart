import 'package:bibliotek/data/constants.dart';
import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';

class IssuedBookCard extends StatelessWidget {
  final Book _book;
  final IssuedBook _issuedBook;

  const IssuedBookCard({@required Book book, @required IssuedBook issuedBook})
      : this._book = book,
        this._issuedBook = issuedBook,
        assert(book != null),
        assert(issuedBook != null);

  @override
  Widget build(BuildContext context) {
    String issueDate = DATE_FORMAT.format(_issuedBook.issuedOn);
    String dueDate = DATE_FORMAT.format(_issuedBook.dueDate);

    return Card(
      child: Wrap(
        children: [
          ExpansionTile(
            title: Text("Book"),
            subtitle: Text(_book.title),
            children: [
              ValueTile(
                label: "Author",
                value: _book.author,
              ),
            ],
          ),
          ValueTile(
            label: "Issue Date",
            value: issueDate,
          ),
          ValueTile(
            label: "Due Date",
            value: dueDate,
          )
        ],
      ),
    );
  }
}
