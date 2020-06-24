import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/user.dart';
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

  Future<void> changePassword(
      {@required User user, @required String password}) async {
    CollectionReference userCollectionReference =
        _firestore.collection('users');
    return userCollectionReference
        .where('id', isEqualTo: user.id)
        .snapshots()
        .map((event) => event.documents)
        .listen((event) {
      event[0].reference.updateData({'password': password});
    });
  }

  Future<void> addBook({@required Book book, @required int copies}) async {
    CollectionReference booksCollectionReference =
        _firestore.collection('books');

    Stream<QuerySnapshot> booksQuerySnapshotStream = booksCollectionReference
        .where('title', isEqualTo: book.title)
        .snapshots();

    bool bookFound = false;
    DocumentReference bookDocumentReference;

    await for (QuerySnapshot bookQuerySnapshot in booksQuerySnapshotStream) {
      List<DocumentSnapshot> bookDocumentReferenceList =
          bookQuerySnapshot.documents;
      if (bookDocumentReferenceList.isNotEmpty) {
        bookFound = true;

        for (DocumentSnapshot bookDocumentSnapshot
            in bookDocumentReferenceList) {
          copies += bookDocumentSnapshot.data['copies'];
          bookDocumentReference = bookDocumentSnapshot.reference;

          break;
        }
      }

      break;
    }

    if (bookFound) {
      bookDocumentReference.updateData({'copies': copies});
    } else {
      Map<String, dynamic> bookData = book.toJson();
      bookData.putIfAbsent('copies', () => copies);
      await booksCollectionReference.document().setData(bookData);
    }
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

  issueBook(
      {@required Book book,
      @required User user,
      @required Timestamp timestamp}) async {
    Stream<QuerySnapshot> booksStream = _firestore
        .collection('books')
        .where('title', isEqualTo: book.title)
        .snapshots();

    DocumentReference bookReference;

    await for (QuerySnapshot snapshot in booksStream) {
      List<DocumentSnapshot> documents = snapshot.documents;

      for (DocumentSnapshot documentSnapshot in documents) {
        bookReference = documentSnapshot.reference;

        break;
      }
      break;
    }

    Stream<QuerySnapshot> userStream = _firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();

    await for (QuerySnapshot snapshot in userStream) {
      List<DocumentSnapshot> documents = snapshot.documents;

      for (DocumentSnapshot documentSnapshot in documents) {
        documentSnapshot.reference.updateData({
          'issued_books': FieldValue.arrayUnion([bookReference.documentID])
        });

        break;
      }

      break;
    }
  }
}
