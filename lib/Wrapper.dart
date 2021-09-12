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

class Wrapper extends StatefulWidget {
  static const routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final myUserAuthStream;
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<Auth>(context, listen: false);
    myUserAuthStream = authProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    authProvider.printCurrentUserEmail();
    // authProvider.reloadUserData();
    // authProvider.printCurrentUserEmail();
    return StreamBuilder<MyUser?>(
        stream: myUserAuthStream,
        builder: (_, AsyncSnapshot<MyUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final MyUser? user = snapshot.data;
            if (user != null && authProvider.getCurrentUser()!.emailVerified) {
              print(user.email);
              return UserAuthToUserDB();
            } else {
              return FullSignIn();
            }
          }
          print('circular from wrapper');
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}

class UserAuthToUserDB extends StatefulWidget {
  const UserAuthToUserDB({Key? key}) : super(key: key);

  @override
  _UserAuthToUserDBState createState() => _UserAuthToUserDBState();
}

class _UserAuthToUserDBState extends State<UserAuthToUserDB> {
  late final Future<void> checkIfAlreadyUserDB;
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<Auth>(context, listen: false);
    checkIfAlreadyUserDB = checkIfUserAddedToDB(authProvider);
  }

  Future<void> checkIfUserAddedToDB(Auth authProvider) async {
    await authProvider.reloadUserData();
    authProvider.printCurrentUserEmail();
    if (authProvider.getCurrentUser() == null) return;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User user = authProvider.getCurrentUser()!;
    final email = user.email;
    final name = user.displayName;
    final userAddedToDatabase =
        await firestore.collection(myNames.usersTable).doc(user.uid).get();
    if (!userAddedToDatabase.exists) {
      await firestore.collection(myNames.usersTable).doc(user.uid).set({
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
    return FutureBuilder(
      future: checkIfAlreadyUserDB,
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
  }
}
