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
}
