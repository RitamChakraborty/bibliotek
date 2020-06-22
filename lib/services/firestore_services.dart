import 'package:bibliotek/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreServices {
  final Firestore _firestore = Firestore.instance;

  Stream<List<DocumentSnapshot>> getUserDocuments({@required String id}) {
    CollectionReference userCollectionReference =
        _firestore.collection('users');
    Stream<List<DocumentSnapshot>> userDocumentSnapshotListStream =
        userCollectionReference
            .where('id', isEqualTo: id)
            .snapshots()
            .map((event) => event.documents);

    return userDocumentSnapshotListStream;
  }

  Future<void> addBook({@required Book book, @required int copies}) {
    CollectionReference booksCollectionReference =
        _firestore.collection('books');
    DocumentReference booksDocumentReference =
        booksCollectionReference.document();

    return booksDocumentReference.setData(book.toJson());
  }

  Stream<QuerySnapshot> getBooks() {
    CollectionReference booksCollectionReference =
        _firestore.collection('books');
    return booksCollectionReference.snapshots();
  }

  Stream<QuerySnapshot> getStudents() {
    CollectionReference usersCollectionReference =
        _firestore.collection('users');
    return usersCollectionReference
        .where('is_admin', isEqualTo: false)
        .snapshots();
  }
}
