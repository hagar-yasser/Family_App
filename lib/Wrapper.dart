import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/FullSignIn.dart';
import 'package:family_app/MyScaffold.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:family_app/objects/MyUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authorization/Auth.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    authProvider.printCurrentUserEmail();
    authProvider.reloadUserData();
    authProvider.printCurrentUserEmail();
    return StreamBuilder<MyUser?>(
        stream: authProvider.user,
        builder: (_, AsyncSnapshot<MyUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final MyUser? user = snapshot.data;
            if (user != null && authProvider.getCurrentUser()!.emailVerified) {
              print(user.email);
              return MyScaffold();
            } else {
              // authProvider.signOut();
              return FullSignIn();
            }
          }
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
