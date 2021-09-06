import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/FullSignIn.dart';
import 'package:family_app/MyScaffold.dart';
import 'package:family_app/myNames.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:family_app/objects/MyUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authorization/Auth.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);
  Future<void> checkIfUserAddedToDB(Auth authProvider) async {
    await authProvider.reloadUserData();
    authProvider.printCurrentUserEmail();
    if (authProvider.getCurrentUser() == null) return;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User user = authProvider.getCurrentUser()!;
    final email = user.email;
    final name = user.displayName;
    final userAddedToDatabase = await firestore
        .collection(myNames.usersTable)
        .where(myNames.email, isEqualTo: email!)
        .get();
    if (userAddedToDatabase.docs.length == 0) {
      await firestore.collection(myNames.usersTable).add({
        myNames.email: email,
        myNames.name: name,
        myNames.family: {},
        myNames.activities: {},
        myNames.familyRequests: {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    authProvider.printCurrentUserEmail();
    // authProvider.reloadUserData();
    // authProvider.printCurrentUserEmail();
    return StreamBuilder<MyUser?>(
        stream: authProvider.user,
        builder: (_, AsyncSnapshot<MyUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final MyUser? user = snapshot.data;
            if (user != null && authProvider.getCurrentUser()!.emailVerified) {
              print(user.email);
              return FutureBuilder(
                future: checkIfUserAddedToDB(authProvider),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Text('an error occured'),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return MyScaffoldWrapper();
                },
              );
            } else {
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
