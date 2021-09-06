import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/myNames.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:family_app/objects/MyUser.dart';

class MyDocument {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? id;
  Stream<DocumentSnapshot> documentStream() {
    return firestore.collection(myNames.usersTable).doc(id).snapshots();
  }

  DocumentReference document() {
    return firestore.collection(myNames.usersTable).doc(id);
  }
}
