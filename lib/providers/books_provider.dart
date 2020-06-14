import 'package:bibliotek/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksProvider {
  FirestoreServices _firestoreServices = FirestoreServices();

  Stream<List<DocumentSnapshot>> getBooks() {
    return _firestoreServices
        .getBooks()
        .map((QuerySnapshot event) => event.documents);
  }
}
