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

  Stream<MyUser?> get user {
    return auth.authStateChanges().map(convertFirbaseUser);
  }

  Future<MyUser?> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;

    return convertFirbaseUser(user);
  }

  Future<MyUser?> handleSignUp(email, password, name) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
     await result.user!.updateDisplayName(name);
    final User user = result.user!;

    return convertFirbaseUser(user);
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
