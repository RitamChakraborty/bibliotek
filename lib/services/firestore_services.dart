import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreServices {
  final Firestore _firestore = Firestore.instance;

  /// Get Stream of [User] object from its reference ID
  Stream<User> getUser({@required String refId}) {
    if (refId != null) {
      CollectionReference collectionReference = _firestore.collection('users');
      return collectionReference
          .document(refId)
          .snapshots()
          .map((DocumentSnapshot snapshot) => snapshot.data)
          .map((Map<String, dynamic> map) => User.fromMap(map: map));
    }

    return null;
  }

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

  Future<void> issueBook(
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

    StudentDetail studentDetail = StudentDetail.fromJson(user.detail);
    studentDetail.issuedBooks.add(bookReference.documentID);

    await for (QuerySnapshot snapshot in userStream) {
      List<DocumentSnapshot> documents = snapshot.documents;

      for (DocumentSnapshot documentSnapshot in documents) {
        await documentSnapshot.reference
            .updateData({'detail': studentDetail.toJson()});

        break;
      }

      break;
    }
  }

  Stream<List<DocumentSnapshot>> getUserFromObject({@required User user}) {
    return _firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots()
        .map((event) => event.documents);
  }

  Stream<DocumentSnapshot> getBook({@required String refId}) {
    return _firestore.collection('books').document(refId).snapshots();
  }

  Stream<List<User>> getPendingUsers() {
    return _firestore
        .collection('users')
        .where('is_admin', isEqualTo: false)
        .snapshots()
        .map((event) => event.documents
            .map((e) => e.data)
            .map((e) => User.fromJson(e))
            .where((element) => element.detail['issued_books'].isNotEmpty)
            .toList());
  }

  Future<void> submitBook(
      {@required String id, @required String bookRef}) async {
    Stream<List<DocumentSnapshot>> stream = _firestore
        .collection('users')
        .where('id', isEqualTo: id)
        .snapshots()
        .map((event) => event.documents);

    await for (List<DocumentSnapshot> list in stream) {
      for (DocumentSnapshot snapshot in list) {
        User student = User.fromJson(snapshot.data);
        (student.detail['issued_books'] as List<dynamic>).remove(bookRef);

        await snapshot.reference.updateData(student.toJson());

        break;
      }

      break;
    }
  }
}
