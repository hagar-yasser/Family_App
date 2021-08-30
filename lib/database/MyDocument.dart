import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:family_app/objects/MyUser.dart';

class MyDocument {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? id;
  Stream<DocumentSnapshot> documentStream() {
    return firestore.collection('Users').doc(id).snapshots();
  }

  DocumentReference document() {
    return firestore.collection('Users').doc(id);
  }
}
