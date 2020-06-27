import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/student_detail.dart';
import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreServices {
  final Firestore _firestore = Firestore.instance;

  /// Get Stream of [User] object from its reference ID
  Stream<User> getUserFromReferenceId({@required String refId}) {
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

  Future<User> getUserFromId({@required String id}) async {
    CollectionReference collectionReference = _firestore.collection('users');
    Stream<List<Map<String, dynamic>>> stream = collectionReference
        .where('id', isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot querySnapshot) =>
            querySnapshot.documents.map((DocumentSnapshot snapshot) {
              Map<String, dynamic> data = snapshot.data;
              data['ref_id'] = snapshot.documentID;
              return data;
            }).toList());

    await for (List<Map<String, dynamic>> list in stream) {
      if (list.isNotEmpty) {
        for (Map<String, dynamic> map in list) {
          User user = User.fromMap(map: map);
          user.refId = map['ref_id'];
          return user;
        }
      }

      break;
    }

    return null;
  }

  Stream<List<Subject>> getSubjects() {
    CollectionReference collectionReference = _firestore.collection('subjects');
    return collectionReference.snapshots().map((QuerySnapshot querySnapshot) =>
        querySnapshot.documents
            .map((DocumentSnapshot snapshot) => snapshot.data)
            .map((Map<String, dynamic> map) => Subject.fromMap(map: map))
            .toList());
  }

  Stream<Book> getBookByRefId({@required String refId}) {
    CollectionReference collectionReference = _firestore.collection('books');
    return collectionReference
        .document(refId)
        .snapshots()
        .map((DocumentSnapshot snapshot) => snapshot.data)
        .map((Map<String, dynamic> map) => Book.fromMap(map: map));
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
      {@required String refId, @required String newPassword}) {
    CollectionReference collectionReference = _firestore.collection('users');
    return collectionReference
        .document(refId)
        .setData({'password': newPassword});
  }

  Future<Subject> getSubjectByName({@required String subject}) async {
    CollectionReference collectionReference = _firestore.collection('subjects');
    Stream<List<Subject>> stream = collectionReference
        .where('subject', isEqualTo: subject)
        .snapshots()
        .map((event) => event.documents.map((e) {
              Map<String, dynamic> map = e.data;
              map['ref_id'] = e.documentID;
              return map;
            }).map((e) {
              Subject subject = Subject.fromMap(map: e);
              subject.refId = e['ref_id'];
              return subject;
            }).toList());

    await for (List<Subject> subjects in stream) {
      if (subjects.isNotEmpty) {
        return subjects.first;
      }

      break;
    }

    return null;
  }

  Future<void> addBook({@required Book book, @required String subject}) async {
    CollectionReference collectionReference = _firestore.collection('books');
    return collectionReference.document().setData(book.map);

//    CollectionReference booksCollectionReference =
//        _firestore.collection('books');
//
//    Stream<QuerySnapshot> booksQuerySnapshotStream = booksCollectionReference
//        .where('title', isEqualTo: book.title)
//        .snapshots();
//
//    bool bookFound = false;
//    DocumentReference bookDocumentReference;
//
//    await for (QuerySnapshot bookQuerySnapshot in booksQuerySnapshotStream) {
//      List<DocumentSnapshot> bookDocumentReferenceList =
//          bookQuerySnapshot.documents;
//      if (bookDocumentReferenceList.isNotEmpty) {
//        bookFound = true;
//
//        for (DocumentSnapshot bookDocumentSnapshot
//            in bookDocumentReferenceList) {
//          copies += bookDocumentSnapshot.data['copies'];
//          bookDocumentReference = bookDocumentSnapshot.reference;
//
//          break;
//        }
//      }
//
//      break;
//    }
//
//    if (bookFound) {
//      bookDocumentReference.updateData({'copies': copies});
//    } else {
//      Map<String, dynamic> bookData = book.toJson();
//      bookData.putIfAbsent('copies', () => copies);
//      await booksCollectionReference.document().setData(bookData);
//    }
  }

  Future<Map<String, dynamic>> getBookExistence({@required Book book}) async {
    // Todo: Complete
    return {
      'book_exists': false,
      'book_ref': null,
    };
  }

  Future<void> updateBookByRefId(
      {@required String refId, @required Book book}) async {
    // Todo: complete
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
