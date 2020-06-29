import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreServices {
  Firestore _firestore;
  CollectionReference _usersCollection;
  CollectionReference _subjectsCollection;
  CollectionReference _booksCollection;
  CollectionReference _issuedBooksCollection;

  FirestoreServices() {
    _firestore = Firestore.instance;
    _usersCollection = _firestore.collection('users');
    _subjectsCollection = _firestore.collection('subjects');
    _booksCollection = _firestore.collection('books');
    _issuedBooksCollection = _firestore.collection('issued_books');
  }

  /// Get Stream of [User] object from its reference ID
  Stream<User> getUserById({@required String refId}) {
    if (refId != null) {
      return _usersCollection
          .document(refId)
          .snapshots()
          .map((DocumentSnapshot snapshot) => snapshot.data)
          .map((Map<String, dynamic> map) => User.fromMap(map: map));
    }

    return null;
  }

  Future<User> getUserFromId({@required String id}) async {
    Stream<List<Map<String, dynamic>>> stream = _usersCollection
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
    return _subjectsCollection.snapshots().map((QuerySnapshot querySnapshot) =>
        querySnapshot.documents
            .map((DocumentSnapshot snapshot) => snapshot.data)
            .map((Map<String, dynamic> map) => Subject.fromMap(map: map))
            .toList());
  }

  Stream<Book> getBookByRefId({@required String refId}) {
    return _booksCollection
        .document(refId)
        .snapshots()
        .map((DocumentSnapshot snapshot) => snapshot.data)
        .map((Map<String, dynamic> map) => Book.fromMap(map: map));
  }

  Future<void> changePassword(
      {@required String refId, @required String newPassword}) {
    return _usersCollection
        .document(refId)
        .updateData({'password': newPassword});
  }

  Future<Subject> getSubjectByName({@required String subject}) async {
    Stream<List<Subject>> stream = _subjectsCollection
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
    Subject subjectObj = await getSubjectByName(subject: subject);

    return _booksCollection.add(book.map).then((value) async {
      String bookRef = value.documentID;
      await _subjectsCollection.document(subjectObj.refId).updateData({
        'books': FieldValue.arrayUnion([bookRef])
      });
    });
  }

  Future<Map<String, dynamic>> getBookExistence({@required Book book}) async {
    Stream<List<DocumentSnapshot>> stream = _booksCollection
        .where('title', isEqualTo: book.title)
        .snapshots()
        .map((event) => event.documents);

    await for (List<DocumentSnapshot> snapshots in stream) {
      if (snapshots.isNotEmpty) {
        for (DocumentSnapshot snapshot in snapshots) {
          return {'book_exists': true, 'book_ref': snapshot.documentID};
        }
      }

      break;
    }

    return {
      'book_exists': false,
      'book_ref': null,
    };
  }

  Future<void> updateBookByRefId(
      {@required String refId, @required int copies}) {
    return _booksCollection
        .document(refId)
        .updateData({'copies': FieldValue.increment(copies)});
  }

  Stream<List<User>> getStudents() {
    return _usersCollection
        .where('is_admin', isEqualTo: false)
        .snapshots()
        .map((event) => event.documents.map((e) {
              Map<String, dynamic> map = e.data;
              map['ref_id'] = e.documentID;

              return map;
            }).map((e) {
              User user = User.fromMap(map: e);
              user.refId = e['ref_id'];

              return user;
            }).toList());
  }

  Stream<List<User>> getStudentsWithPendingBooks() {
    return _firestore
        .collection('users')
        .where('is_admin', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot querySnapshot) =>
            querySnapshot.documents.map((DocumentSnapshot snapshot) {
              Map<String, dynamic> map = snapshot.data;
              map['ref_id'] = snapshot.documentID;

              return map;
            }).map((Map<String, dynamic> map) {
              User user = User.fromMap(map: map);
              user.refId = map['ref_id'];

              return user;
            }).toList());
  }

  Future<void> issueBook({@required IssuedBook issuedBook}) async {
    await _issuedBooksCollection.add(issuedBook.map).then((value) {
      issuedBook.refId = value.documentID;
    });

    dynamic issuedBookRef = issuedBook.refId;
    String adminRef = issuedBook.issuedBy;
    String studentRef = issuedBook.issuedTo;

    await _usersCollection.document(adminRef).updateData({
      'issued_books': FieldValue.arrayUnion([issuedBookRef])
    });
    await _usersCollection.document(studentRef).updateData({
      'issued_books': FieldValue.arrayUnion([issuedBookRef])
    });
  }

  Future<void> submitBook({
    @required String adminRef,
    @required String studentRef,
    @required String bookRef,
  }) async {
    dynamic ref = bookRef;

    await _usersCollection
        .document(adminRef)
        .updateData({'issued_book': FieldValue.arrayRemove(ref)});
    await _usersCollection
        .document(studentRef)
        .updateData({'issued_book': FieldValue.arrayRemove(ref)});
    await _issuedBooksCollection.document(bookRef).delete();
  }

  Stream<IssuedBook> getIssuedBookById({@required String refId}) {
    return _issuedBooksCollection
        .document(refId)
        .snapshots()
        .map((DocumentSnapshot snapshot) => snapshot.data)
        .map((Map<String, dynamic> map) => IssuedBook.fromMap(map: map));
  }

  Future<Map<String, dynamic>> getIssuedBookAsFutureById(
      {@required String issuedBookRef}) async {
    IssuedBook issuedBook;
    Stream<IssuedBook> issuedBookStream =
        getIssuedBookById(refId: issuedBookRef);

    await for (IssuedBook data in issuedBookStream) {
      issuedBook = data;
      break;
    }

    Book book;
    Stream<Book> bookStream = getBookByRefId(refId: issuedBook.book);

    await for (Book data in bookStream) {
      book = data;
      break;
    }

    return {'issued_book': issuedBook, 'book': book};
  }
}
