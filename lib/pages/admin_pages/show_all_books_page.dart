import 'package:bibliotek/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowAllBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BooksProvider booksProvider = Provider.of<BooksProvider>(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("All Books"),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: booksProvider.getBooks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title:
                            Text("${snapshot.data[index].data['book_name']}"),
                        subtitle: Text(
                            "by ${snapshot.data[index].data['author_name']}\nSuject: ${snapshot.data[index].data['subject_name']}"),
                        trailing: Text(
                            "${snapshot.data[index].data['number_of_copies']}"),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: snapshot.data.length,
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
