import 'package:bibliotek/models/subject.dart';
import 'package:bibliotek/services/firestore_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FirestoreServices firestoreServices = FirestoreServices();

  test('Get subject by name', () async {
    Subject subject = await firestoreServices.getSubjectByName(
        subject: "Data Structure and Algorithm");

    expect(subject.refId, "IW9aWGJLShr63OLeaAzt");
  });
}
