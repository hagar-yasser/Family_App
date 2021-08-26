import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:family_app/objects/MyUser.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  MyUser? convertFirbaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(user.email, user.displayName);
  }

  void reloadUserData() async {
    if (auth.currentUser != null) {
      try {
        await auth.currentUser!.reload();
      } on Exception catch (e) {
        print("couldn't reload currentUser " + e.toString());
      }
    }
  }

  Stream<MyUser?> get user {
    return auth.authStateChanges().map(convertFirbaseUser);
  }

  Future<MyUser?> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;
    if (!user.emailVerified) {
      await auth.signOut();
      throw new Exception("Account email not verified yet");
    } else {
      await checkIfUserAddedToDB(user);
    }

    return convertFirbaseUser(user);
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> checkIfUserAddedToDB(User user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final email=user.email;
    final name=user.displayName;
    final userAddedToDatabase = await firestore
        .collection("Users")
        .where('email', isEqualTo: email!.replaceAll('.', '_'))
        .get();
    if (userAddedToDatabase.docs.length == 0) {
      await firestore.collection('Users').add({
        'email': email.replaceAll('.', '_'),
        'name': name,
        'family': {},
        'activities': {},
        'familyRequests': {}
      });
    }
  }

  Future<MyUser?> handleSignUp(email, password, name) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await result.user!.updateDisplayName(name);

    await auth.currentUser!.sendEmailVerification();

    final User user = result.user!;

    return convertFirbaseUser(user);
  }

  void printCurrentUserEmail() {
    if (auth.currentUser != null) {
      print(convertFirbaseUser(auth.currentUser)!.email);
    } else {
      print("no current user");
    }
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
