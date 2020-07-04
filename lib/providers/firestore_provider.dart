import 'package:bibliotek/models/book.dart';
import 'package:bibliotek/models/issued_book.dart';
import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/models/user.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:meta/meta.dart';

class FireStoreProvider {
  final FirestoreServices _firestoreServices;

  const FireStoreProvider({@required FirestoreServices firestoreServices})
      : this._firestoreServices = firestoreServices,
        assert(firestoreServices != null);

  Stream<User> getUserById({@required String refId}) =>
      _firestoreServices.getUserById(refId: refId);

  Future<User> getUserFromId({@required String id}) =>
      _firestoreServices.getUserFromId(id: id);

  Stream<List<Subject>> getSubjects() => _firestoreServices.getSubjects();

  Stream<Book> getBookByRefId({@required String refId}) =>
      _firestoreServices.getBookByRefId(refId: refId);

  Stream<Book> getAvailableBookByRefId({@required String refId}) =>
      _firestoreServices.getAvailableBookByRefId(refId: refId);

  Future<void> changePassword(
          {@required String refId, @required String newPassword}) =>
      _firestoreServices.changePassword(refId: refId, newPassword: newPassword);

  Future<Subject> getSubjectByName({@required String subject}) =>
      _firestoreServices.getSubjectByName(subject: subject);

  Future<void> addBook({@required Book book, @required String subject}) =>
      _firestoreServices.addBook(book: book, subject: subject);

  Future<Map<String, dynamic>> getBookExistence({@required Book book}) =>
      _firestoreServices.getBookExistence(book: book);

  Future<void> updateBookByRefId(
          {@required String refId, @required int copies}) =>
      _firestoreServices.updateBookByRefId(refId: refId, copies: copies);

  Stream<List<User>> getStudents() => _firestoreServices.getStudents();

  Stream<List<IssuedBook>> getIssuedBooks() =>
      _firestoreServices.getIssuedBooks();

  Stream<List<User>> getStudentsWithPendingBooks(
          {@required List<dynamic> issuedBookRefs}) =>
      _firestoreServices.getStudentsWithPendingBooks(
          issuedBookRefs: issuedBookRefs);

  Future<List<Book>> getBooksIssuedByStudent({@required User student}) =>
      _firestoreServices.getBooksIssuedByStudent(student: student);

  Future<void> issueBook({@required IssuedBook issuedBook}) =>
      _firestoreServices.issueBook(issuedBook: issuedBook);

  Future<void> submitBook({@required IssuedBook issuedBook}) =>
      _firestoreServices.submitBook(issuedBook: issuedBook);

  Stream<IssuedBook> getIssuedBookById({@required String refId}) =>
      _firestoreServices.getIssuedBookById(refId: refId);

  Future<Map<String, dynamic>> getIssuedBookAsFutureById(
          {@required String issuedBookRef}) =>
      _firestoreServices.getIssuedBookAsFutureById(
          issuedBookRef: issuedBookRef);
}
