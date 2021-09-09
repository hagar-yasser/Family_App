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

  Future<void> reloadUserData() async {
    print('current auth user is ' + auth.currentUser.toString());
    if (auth.currentUser != null) {
      try {
        await auth.currentUser!.reload();
      } on Exception catch (e) {
        print("couldn't reload currentUser " + e.toString());
      }
    }
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
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
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }

    return convertFirbaseUser(user);
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> handleSignUp(email, password, name) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await result.user!.updateDisplayName(name);

    await auth.currentUser!.sendEmailVerification();

    final User user = result.user!;

    return await auth.signOut();
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
