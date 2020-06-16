import 'package:bibliotek/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsProvider {
  FirestoreServices _firestoreServices = FirestoreServices();

  Stream<List<DocumentSnapshot>> getStudents() {
    return _firestoreServices.getStudents().map((event) => event.documents);
  }
}
