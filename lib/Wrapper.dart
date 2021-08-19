import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/FullSignIn.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:family_app/objects/MyUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authorization/Auth.dart';

class Wrapper extends StatelessWidget {
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
            if (user != null&&authProvider.getCurrentUser()!.emailVerified) {
              print(user.email);
              return ActivityBrief(
                  activity: Activity(
                      'Eating together',
                      70,
                      ['Eman Ahmed', 'Omar Yasser', 'Yasser AbdelRaouf'],
                      1,
                      1));
            }
            return FullSignIn();
          }
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
