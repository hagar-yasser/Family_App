import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRectangularButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Family extends StatefulWidget {
  const Family({Key? key}) : super(key: key);

  @override
  _FamilyState createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!.replaceAll('.', '_');
    return StreamBuilder(
      stream: firestore
          .collection('Users')
          .where('email', isEqualTo: myEmail)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        Map family = snapshot.data!.docs[0]['family'];

        Map familyRequests = snapshot.data!.docs[0]['familyRequests'];

        return Center(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FamilyType(
                      family: family, familyRequests: familyRequests),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FamilyType extends StatefulWidget {
  final Map family;
  final Map familyRequests;
  const FamilyType(
      {Key? key, required this.family, required this.familyRequests})
      : super(key: key);

  @override
  _FamilyTypeState createState() => _FamilyTypeState();
}

class _FamilyTypeState extends State<FamilyType> {
  bool showRequests = false;
  var tween = Tween(begin: Offset(-1.0, 0.0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 2,
            ),
            MyButton(
              action: () {
                setState(() {
                  showRequests = false;
                });
              },
              text: 'My Family',
            ),
            Spacer(
              flex: 1,
            ),
            MyButton(
              action: () {
                setState(() {
                  showRequests = true;
                });
              },
              text: 'Family Requests',
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                  child: child, position: animation.drive(tween));
            },
            child: showRequests
                ? FamilyRequests(familyRequests: widget.familyRequests)
                : FamilyMembers(
                    family: widget.family,
                  ))
      ],
    );
  }
}

class FamilyMembers extends StatelessWidget {
  final Map family;
  const FamilyMembers({Key? key, required this.family}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    List familyIDs = [];
    family.forEach((key, value) {
      familyIDs.add(key);
    });
    return Container(
      height: 400,
      width: 300,
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Scrollbar(
          interactive: true,
          isAlwaysShown: true,
          showTrackOnHover: true,
          controller: _controller,
          child: ListView.separated(
            itemCount: familyIDs.length,
            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  family[familyIDs[index]]['name'],
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }
}

class FamilyRequests extends StatelessWidget {
  final Map familyRequests;
  const FamilyRequests({Key? key, required this.familyRequests})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    User? user = Provider.of<Auth>(context).getCurrentUser();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String myEmail = user!.email!.replaceAll('.', '_');
    List familyRequestsIDs = [];
    if(familyRequests[myEmail]!=null)
    familyRequests[myEmail].forEach((key, value) {
      familyRequestsIDs.add(key);
    });
    return Container(
      height: 400,
      width: 400,
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Scrollbar(
          interactive: true,
          isAlwaysShown: true,
          showTrackOnHover: true,
          controller: _controller,
          child: ListView.separated(
            itemCount: familyRequestsIDs.length,
            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children:[ Text(
                  familyRequestsIDs[index],
                  style: TextStyle(fontSize: 20),
                ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          color: Colors.redAccent,
                          onPressed: () async {
                            QuerySnapshot myUser = await firestore
                                .collection('Users')
                                .where('email', isEqualTo: myEmail)
                                .get();
                            QuerySnapshot requestedUser = await firestore
                                .collection('Users')
                                .where('email',
                                    isEqualTo: familyRequestsIDs[index])
                                .get();
                            await firestore
                                .collection('Users')
                                .doc(myUser.docs[0].id)
                                .update({
                              'familyRequests.' +
                                  myEmail +
                                  "." +
                                  familyRequestsIDs[index]: FieldValue.delete()
                            });
                            await firestore
                                .collection('Users')
                                .doc(requestedUser.docs[0].id)
                                .update({
                              'familyRequests.' +
                                  myEmail
                                  : FieldValue.delete()
                            });

                          },
                          icon: Icon(Icons.cancel_outlined)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          color: Color(0xffEA907A),
                          onPressed: () async{
                            QuerySnapshot myUser = await firestore
                                .collection('Users')
                                .where('email', isEqualTo: myEmail)
                                .get();
                            QuerySnapshot requestedUser = await firestore
                                .collection('Users')
                                .where('email',
                                    isEqualTo: familyRequestsIDs[index])
                                .get();
                            await firestore
                                .collection('Users')
                                .doc(myUser.docs[0].id)
                                .update({
                              'familyRequests.' +
                                  myEmail +
                                  "." +
                                  familyRequestsIDs[index]: FieldValue.delete(),
                              'family.'+familyRequestsIDs[index]+'.name':requestedUser.docs[0]['name']
                            });
                            await firestore
                                .collection('Users')
                                .doc(requestedUser.docs[0].id)
                                .update({
                              'familyRequests.' +
                                  myEmail 
                                 : FieldValue.delete(),
                              'family.'+myEmail+'.name':myUser.docs[0]['name']
                            });
                          },
                          icon: Icon(Icons.check_circle_outline_rounded)),
                    ),
                  ],
                ),]
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }
}
