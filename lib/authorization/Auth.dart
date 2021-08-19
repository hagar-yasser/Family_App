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
      auth.signOut();
      throw new Exception("Account email not verified yet");
    }
    return convertFirbaseUser(user);
  }

  User? getCurrentUser() {
    return auth.currentUser;
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
