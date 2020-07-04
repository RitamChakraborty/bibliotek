import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book _book;
  final bool _showCopies;
  final bool _showAvailability;

  const BookCard(
      {@required Book book,
      bool showCopies = true,
      bool showAvailability = false})
      : this._book = book,
        this._showCopies = showCopies,
        this._showAvailability = showAvailability,
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
              _showCopies
                  ? ValueTile(
                      label: "Number of copies", value: _book.copies.toString())
                  : Container(),
              _showAvailability
                  ? ListTile(
                      title:
                          Text(_book.copies > 0 ? "Available" : "Unavailable"),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
