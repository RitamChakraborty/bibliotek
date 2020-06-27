import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book _book;

  const BookCard({@required Book book})
      : this._book = book,
        assert(book != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              ValueTile(label: "Title", value: _book.title),
              ValueTile(label: "Author", value: _book.author),
              ValueTile(
                  label: "Number of copies", value: _book.copies.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
