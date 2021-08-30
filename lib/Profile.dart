import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRectangularButton.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${authProvider.getCurrentUser()!.displayName}",
                style: TextStyle(fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  // height: MediaQuery.of(context).size.height * 0.4,
                  child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Add a Family Member",
                              style: TextStyle(fontSize: 20),
                            ),
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  labelText: "Type the member's email"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: MyRoundedLoadingButton(
                                child: Text('Send family request'),
                                action: () async {
                                  await sendFamilyRequest(_controller.text,authProvider.getCurrentUser());
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
              MyRoundedLoadingButton(
                  action: () async {
                    await authProvider.signOut();
                  },
                  child: Text('Sign Out'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendFamilyRequest(String email,User? user) async {
    if (email.isEmpty) {
      _showMessageDialog(context, "please enter a valid email", "");
      return;
    } else {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
     
      String myEmail = user!.email!.replaceAll('.', '_');
      email = email.replaceAll('.', '_');
      QuerySnapshot myUser = await firestore
          .collection('Users')
          .where('email', isEqualTo: myEmail)
          .get();
      QuerySnapshot requestedUser = await firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();
      if (requestedUser.docs.length == 0) {
        _showMessageDialog(
            context, "There is no registered user with this email", "");
        return;
      }
      Map family = myUser.docs[0]['family'];
      if(family[email]!=null){
        _showMessageDialog(context, "You are already family members", "");
      }
      Map familyRequests = myUser.docs[0]['familyRequests'];
      if (familyRequests[email] != null ||
          (familyRequests[myEmail] != null &&
              familyRequests[myEmail][email] != null)) {
        _showMessageDialog(context, "Family Request already sent", "");
        return;
      }
      await firestore
          .collection('Users')
          .doc(myUser.docs[0].id)
          .update({'familyRequests.' + email + '.' + myEmail: 'pending'});
      await firestore
          .collection('Users')
          .doc(requestedUser.docs[0].id)
          .update({'familyRequests.' + email + '.' + myEmail: 'pending'});
    }
  }

  void _showMessageDialog(BuildContext context, String title, String content) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  content,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MyButton(
                action: () {
                  Navigator.of(context).pop();
                },
                text: 'OK'),
          ],
        );
      },
    );
  }
}
