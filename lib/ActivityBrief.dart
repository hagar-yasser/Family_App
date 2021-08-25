import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/MySmallRoundedButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:family_app/objects/Activity.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ActivityBrief extends StatefulWidget {
  const ActivityBrief({Key? key}) : super(key: key);
  static const routeName = '/activityBrief';

  @override
  _ActivityBriefState createState() => _ActivityBriefState();
}

class _ActivityBriefState extends State<ActivityBrief> {
 

  // Future<QuerySnapshot> getUserAndCheckActivities(
  //     FirebaseFirestore firestore, User? user) async {
  //   Future<QuerySnapshot> snapshot = firestore
  //       .collection('Users')
  //       .where('email', isEqualTo: user!.email)
  //       .get();
  //   QuerySnapshot mySnapshot = await snapshot;
  //   await checkActivitiesStates(firestore, mySnapshot.docs[0].id);
  //   return snapshot;
  // }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber[800],
        onPressed: () {
          Navigator.of(context).pushNamed('/addActivity');
        },
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore
        .collection('Users')
        .where('email', isEqualTo: user!.email)
        .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          // if (snapshot.data != null &&
          //     snapshot.data!.docs[0]['activities'].length == 0) {
          //   return Center();
          // }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<DocumentSnapshot>(
              stream: firestore
                  .collection('Users')
                  .doc(snapshot.data!.docs[0].id)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> docSnapshot) {
                if (docSnapshot.hasError || docSnapshot.data == null) {
                  return Text(
                      'Something went wrong when loading the user data');
                }
                if (docSnapshot.connectionState == ConnectionState.waiting) {
                  return Text('loading User data');
                }
                return Center(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                      });
                    },
                    child: Scrollbar(
                      isAlwaysShown: true,
                      interactive: true,
                      showTrackOnHover: true,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: docSnapshot.data!['activities'].length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          List activities = docSnapshot.data!['activities'];
                          List members = activities[index]['members'] != null
                              ? activities[index]['members'] as List
                              : [];
                          return Container(
                            height: 200,
                            width: 300,
                            child: Card(
                              color: Colors.white,
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            32, 8.0, 8.0, 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text.rich(TextSpan(
                                                      text: activities[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                          fontSize: 20))),
                                                  Text(
                                                      (activities[index]
                                                                  ['points'])
                                                              .toString() +
                                                          "/" +
                                                          (activities[index]
                                                                          [
                                                                          'reportRate'] ==
                                                                      activities[
                                                                              index]
                                                                          [
                                                                          'activityRate']
                                                                  ? 1
                                                                  : 7)
                                                              .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffAACDBE),
                                                          fontSize: 30)),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      expandListOfStrings(
                                                          (members)),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              color: Color(0xffF7A440),
                                              onPressed: () async {
                                                var actionInsideFullActivity =
                                                    await Navigator.of(context)
                                                        .pushNamed(
                                                            '/fullActivity',
                                                            arguments:
                                                                activities[
                                                                    index]);
                                                print(actionInsideFullActivity);
                                                if (actionInsideFullActivity !=
                                                    null) {
                                                  if (actionInsideFullActivity ==
                                                      "Done") {
                                                    checkActivityDone(
                                                        activities,
                                                        index,
                                                        firestore,
                                                        docSnapshot);
                                                  } else {
                                                    activities.removeAt(index);
                                                    await firestore
                                                        .collection("Users")
                                                        .doc(docSnapshot
                                                            .data!.id)
                                                        .update({
                                                      'activities': activities
                                                    });
                                                  }
                                                }
                                              },
                                              icon: Icon(Icons
                                                  .keyboard_arrow_right_rounded),
                                              iconSize: 40,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    MyRoundedLoadingButton(
                                      action: () async {
                                        await checkActivityDone(activities,
                                            index, firestore, docSnapshot);
                                      },
                                      child: Icon(Icons.check),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Future<void> checkActivityDone(
      activities, index, firestore, docSnapshot) async {
    DateTime clickedTime = DateTime.now().toUtc();
    DateTime? lastDone = (activities[index]['lastDone']) == null
        ? null
        : (activities[index]['lastDone']).toDate();
    DateTime timeAdded = (activities[index]['timeAdded']).toDate();
    DateTime endTime = (activities[index]['endTime']).toDate();
    if (endTime.compareTo(clickedTime) > 0 &&
        (lastDone == null ||
            (activities[index]['activityRate'] == 'Daily' &&
                dayFromTo(timeAdded, lastDone) !=
                    dayFromTo(timeAdded, clickedTime)))) {
      final previousPoints = activities[index]['points'];
      activities[index]['points'] = previousPoints + 1;
      activities[index]['lastDone'] = clickedTime;
      await firestore
          .collection("Users")
          .doc(docSnapshot.data!.id)
          .update({'activities': activities});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Activty already checked for this " +
              (activities[index]['activityRate'] == 'Daily'
                  ? "Day"
                  : "Week"))));
    }
  }

  String expandListOfStrings(List list) {
    String result = "";
    for (int i = 0; i < list.length; i++) {
      result += list[i]!['name'];
      if (i < list.length - 1) {
        result += ", ";
      }
    }
    return result;
  }

  int dayFromTo(DateTime startTime, DateTime doneTime) {
    return doneTime.toUtc().difference(startTime.toUtc()).inDays;
  }
}
