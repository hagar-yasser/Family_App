import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRectangularButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/myNames.dart';
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
    String myEmail = user!.email!;
    return StreamBuilder(
      stream: firestore
          .collection(myNames.usersTable)
          .where(myNames.email, isEqualTo: myEmail)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        Map family = snapshot.data!.docs[0][myNames.family];

        Map familyRequests = snapshot.data!.docs[0][myNames.familyRequests];

        return Center(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: FamilyType(family: family, familyRequests: familyRequests),
            // child: ListView(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(30.0),
            // child: FamilyType(
            //     family: family, familyRequests: familyRequests),
            //     )
            //   ],
            // ),
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Color(0xffEA907A)),
                  tabs: [
                    Tab(
                      child: Text(
                        "My Family",
                        style: TextStyle(
                            fontFeatures: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .fontFeatures,
                            fontSize: 15,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                    ),
                    Tab(
                      child: Text("Family Requests",
                          style: TextStyle(
                              fontFeatures: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .fontFeatures,
                              fontSize: 15,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color)),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              FamilyMembers(
                family: widget.family,
              ),
              FamilyRequests(familyRequests: widget.familyRequests)
            ],
          ),
        ));
    // return Column(
    //   children: [
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Spacer(
    //           flex: 2,
    //         ),
    //         MyButton(
    //           action: () {
    //             setState(() {
    //               showRequests = false;
    //             });
    //           },
    //           text: 'My Family',
    //         ),
    //         Spacer(
    //           flex: 1,
    //         ),
    //         MyButton(
    //           action: () {
    //             setState(() {
    //               showRequests = true;
    //             });
    //           },
    //           text: 'Family Requests',
    //         ),
    //         Spacer(
    //           flex: 2,
    //         ),
    //       ],
    //     ),
    //     AnimatedSwitcher(
    //         duration: const Duration(milliseconds: 500),
    //         transitionBuilder: (Widget child, Animation<double> animation) {
    //           return SlideTransition(
    //               child: child, position: animation.drive(tween));
    //         },
    //         child: showRequests
    //             ? FamilyRequests(familyRequests: widget.familyRequests)
    // : FamilyMembers(
    //     family: widget.family,
    //   ))
    //   ],
    // );
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
      // height: 400,
      // width: 300,
      child: (familyIDs.length == 0)
          ? Center(
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "There are no family members. Try to send family requests to your family members from your profile page.",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          : Scrollbar(
              interactive: true,
              isAlwaysShown: true,
              showTrackOnHover: true,
              controller: _controller,
              child: ListView.separated(
                itemCount: familyIDs.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(
                        family[familyIDs[index]][myNames.name],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
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
    String myEmail = user!.email!;
    List familyRequestsIDs = [];
    if (familyRequests[myEmail] != null)
      familyRequests[myEmail].forEach((key, value) {
        familyRequestsIDs.add(key);
      });
    return Container(
      // height: 400,
      // width: 400,
      child: (familyRequestsIDs.length == 0)
          ? Center(
              child: Card(
                elevation: 8,
                child: Text(
                  "There are no family requests",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          : Scrollbar(
              interactive: true,
              isAlwaysShown: true,
              showTrackOnHover: true,
              controller: _controller,
              child: ListView.separated(
                itemCount: familyRequestsIDs.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8,
                    child: Column(children: [
                      Text(
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
                                      .collection(myNames.usersTable)
                                      .where(myNames.email, isEqualTo: myEmail)
                                      .get();
                                  QuerySnapshot requestedUser = await firestore
                                      .collection(myNames.usersTable)
                                      .where(myNames.email,
                                          isEqualTo: familyRequestsIDs[index])
                                      .get();
                                  await firestore
                                      .collection(myNames.usersTable)
                                      .doc(myUser.docs[0].id)
                                      .set({
                                    myNames.familyRequests: {
                                      myEmail: {
                                        familyRequestsIDs[index]:
                                            FieldValue.delete()
                                      }
                                    }
                                  }, SetOptions(merge: true));
                                  await firestore
                                      .collection(myNames.usersTable)
                                      .doc(requestedUser.docs[0].id)
                                      .set({
                                    myNames.familyRequests: {
                                      myEmail: FieldValue.delete()
                                    }
                                  }, SetOptions(merge: true));
                                },
                                icon: Icon(Icons.cancel_outlined)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                color: Color(0xffEA907A),
                                onPressed: () async {
                                  QuerySnapshot myUser = await firestore
                                      .collection(myNames.usersTable)
                                      .where(myNames.email, isEqualTo: myEmail)
                                      .get();
                                  QuerySnapshot requestedUser = await firestore
                                      .collection(myNames.usersTable)
                                      .where(myNames.email,
                                          isEqualTo: familyRequestsIDs[index])
                                      .get();
                                  await firestore
                                      .collection(myNames.usersTable)
                                      .doc(myUser.docs[0].id)
                                      .set({
                                    myNames.familyRequests: {
                                      myEmail: {
                                        familyRequestsIDs[index]:
                                            FieldValue.delete()
                                      }
                                    },
                                    myNames.family: {
                                      familyRequestsIDs[index]: {
                                        myNames.name: requestedUser.docs[0]
                                            [myNames.name]
                                      }
                                    }
                                  }, SetOptions(merge: true));
                                  await firestore
                                      .collection(myNames.usersTable)
                                      .doc(requestedUser.docs[0].id)
                                      .set({
                                    myNames.familyRequests: {
                                      myEmail: FieldValue.delete()
                                    },
                                    myNames.family: {
                                      myEmail: {
                                        myNames.name: myUser.docs[0]
                                            [myNames.name]
                                      }
                                    }
                                  }, SetOptions(merge: true));
                                },
                                icon: Icon(Icons.check_circle_outline_rounded)),
                          ),
                        ],
                      ),
                    ]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
    );
  }
}
