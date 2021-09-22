import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/MySmallRoundedButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/database/MyDocument.dart';
import 'package:family_app/myNames.dart';
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
  ScrollController _scrollController = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final Stream<DocumentSnapshot> myUserDataStream;
  @override
  void initState() {
    super.initState();
    String? id = Provider.of<MyDocument>(context, listen: false).id;
    myUserDataStream =
        firestore.collection(myNames.usersTable).doc(id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!;
    String? id = Provider.of<MyDocument>(context).id;
    double height = (MediaQuery.of(context).size.height);
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    // Height (without status bar)
    double height2 = height - padding.top;

    // Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;
    // print("height" + height.toString());
    // print("height1" + height1.toString());
    // print("height2" + height2.toString());
    // print("height3" + height3.toString());
    // print("text scale factor "+MediaQuery.of(context).textScaleFactor.toString());
    // print("width"+(MediaQuery.of(context).size.width*MediaQuery.of(context).devicePixelRatio).toString());
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber[800],
          onPressed: () {
            Navigator.of(context).pushNamed('/addActivity');
          },
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: myUserDataStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> docSnapshot) {
              print('from activityBrief stream');
              if (docSnapshot.hasError) {
                return Center(
                  child:
                      Text('Something went wrong when loading the user data'),
                );
              }
              if (docSnapshot.connectionState == ConnectionState.waiting ||
                  !docSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              // return Center(
              //   child: MyRoundedLoadingButton(
              //     child: Text('Delete field'),
              //     action: () async {
              //       QuerySnapshot s = await firestore
              //           .collection('Users')
              //           .where('email', isEqualTo: "hagar.ay7aga@ay7aga[jf")
              //           .get();
              //       await firestore.collection('Users').doc(s.docs[0].id).set({
              //         'activities': {
              //           'activity.awelwa7ed': FieldValue.delete()
              //         }
              //       }, SetOptions(merge: true));

              //     },
              //   ),
              // );
              final len = docSnapshot.data![myNames.activities].length;
              return Center(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: (len == null || len == 0)
                      ? Center(
                          child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "There are no activities. Add an activity from the add (+) button below.",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      : Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          interactive: true,
                          showTrackOnHover: true,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount:
                                docSnapshot.data![myNames.activities].length ??
                                    0,
                            itemBuilder: (BuildContext context, int index) {
                              Map activities =
                                  docSnapshot.data![myNames.activities];
                              List activitiesIDs = [];
                              activities.forEach((key, value) {
                                activitiesIDs.add(key);
                              });
                              Map members = activities[activitiesIDs[index]]
                                  [myNames.members] as Map;
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          activities[
                                                                  activitiesIDs[
                                                                      index]]
                                                              [myNames.name],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                          // strutStyle: StrutStyle(
                                                          //     forceStrutHeight: true),
                                                        ),
                                                      ),
                                                      Text(
                                                        (activities[activitiesIDs[index]]
                                                                            [myNames.members]
                                                                        [
                                                                        myEmail]
                                                                    [myNames
                                                                        .points])
                                                                .toString() +
                                                            "/" +
                                                            (activities[activitiesIDs[index]]
                                                                            [
                                                                            myNames
                                                                                .reportRate] ==
                                                                        activities[activitiesIDs[index]]
                                                                            [
                                                                            myNames.activityRate]
                                                                    ? 1
                                                                    : 7)
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffAACDBE),
                                                            fontSize: 30),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: 200,
                                                          child: Text(
                                                            expandToListOfStrings(
                                                                (members)),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  color: Color(0xffF7A440),
                                                  onPressed: () async {
                                                    var actionInsideFullActivity =
                                                        await Navigator.of(
                                                                context)
                                                            .pushNamed(
                                                                '/fullActivity',
                                                                arguments: activities[
                                                                    activitiesIDs[
                                                                        index]]);
                                                    print(
                                                        actionInsideFullActivity);
                                                    if (actionInsideFullActivity !=
                                                        null) {
                                                      if (actionInsideFullActivity ==
                                                          "Done") {
                                                        checkActivityDone(
                                                            activities[
                                                                activitiesIDs[
                                                                    index]],
                                                            activitiesIDs[
                                                                index],
                                                            myEmail,
                                                            firestore,
                                                            docSnapshot);
                                                      } else {
                                                        //REMOVE ME FROM THE LIST OF MEMBERS OF THIS ACTIVITY IN THE ACTIVITIES TABLE
                                                        final internetCheck =
                                                            await firestore
                                                                .collection(myNames
                                                                    .usersTable)
                                                                .doc(docSnapshot
                                                                    .data!.id)
                                                                .get();
                                                        if (internetCheck
                                                            .metadata
                                                            .isFromCache) {
                                                          if (this.mounted)
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text("A problem occurred when quitting the activity. Please check your internet connectivity")));
                                                        } else {
                                                          WriteBatch
                                                              quitActivity =
                                                              firestore.batch();
                                                          quitActivity.set(
                                                              firestore
                                                                  .collection(
                                                                      myNames
                                                                          .activitiesTable)
                                                                  .doc(activitiesIDs[
                                                                      index]),
                                                              {
                                                                myNames.members:
                                                                    {
                                                                  myEmail:
                                                                      FieldValue
                                                                          .delete()
                                                                }
                                                              },
                                                              SetOptions(
                                                                  merge: true));
                                                          // await firestore
                                                          //     .collection(myNames
                                                          //         .activitiesTable)
                                                          //     .doc(
                                                          //         activitiesIDs[
                                                          //             index])
                                                          //     .set(
                                                          //         {
                                                          //       myNames.members:
                                                          //           {
                                                          //         myEmail:
                                                          //             FieldValue
                                                          //                 .delete()
                                                          //       }
                                                          //     },
                                                          //         SetOptions(
                                                          //             merge:
                                                          //                 true));
                                                          //REMOVE THIS ACTIVITY FROM MY ACTIVITIES IN THE USER TABLE
                                                          // activities.remove(
                                                          //     activitiesIDs[
                                                          //         index]);
                                                          quitActivity.set(
                                                              firestore
                                                                  .collection(
                                                                      myNames
                                                                          .usersTable)
                                                                  .doc(
                                                                      docSnapshot
                                                                          .data!
                                                                          .id),
                                                              {
                                                                myNames
                                                                    .activities: {
                                                                  activitiesIDs[
                                                                          index]:
                                                                      FieldValue
                                                                          .delete()
                                                                }
                                                              },
                                                              SetOptions(
                                                                  merge: true));
                                                          // await firestore
                                                          //     .collection(myNames
                                                          //         .usersTable)
                                                          //     .doc(docSnapshot
                                                          //         .data!.id)
                                                          //     .set(
                                                          //         {
                                                          //       myNames
                                                          //           .activities: {
                                                          //         activitiesIDs[
                                                          //                 index]:
                                                          //             FieldValue
                                                          //                 .delete()
                                                          //       }
                                                          //     },
                                                          //         SetOptions(
                                                          //             merge:
                                                          //                 true));
                                                          quitActivity.commit();
                                                        }
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
                                          key: Key(activitiesIDs[index]),
                                          action: () async {
                                            await checkActivityDone(
                                                activities[
                                                    activitiesIDs[index]],
                                                activitiesIDs[index],
                                                myEmail,
                                                firestore,
                                                docSnapshot);
                                          },
                                          child: Text('Done'),
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
            }));
  }

  Future<void> checkActivityDone(Map activity, activityID, email,
      FirebaseFirestore firestore, docSnapshot) async {
    DateTime clickedTime = DateTime.now().toUtc();
    DateTime? lastDone = (activity[myNames.lastDone]) == null
        ? null
        : (activity[myNames.lastDone]).toDate();
    DateTime timeAdded = (activity[myNames.timeAdded]).toDate();
    DateTime endTime = (activity[myNames.endTime]).toDate();
    if (endTime.compareTo(clickedTime) > 0 &&
        (lastDone == null ||
            (activity[myNames.activityRate] == 'Daily' &&
                dayFromTo(timeAdded, lastDone) !=
                    dayFromTo(timeAdded, clickedTime)))) {
      final previousPoints = activity[myNames.members][email][myNames.points];
      activity[myNames.members][email][myNames.points] = previousPoints + 1;
      activity[myNames.lastDone] = clickedTime;
      //UPDATE THE ACTIVITY.ID IN THE ACTIVITIES TABLE WITH MY POINTS
      final internetCheck = await firestore
          .collection(myNames.usersTable)
          .doc(docSnapshot.data!.id)
          .get();
      if (internetCheck.metadata.isFromCache) {
        if (this.mounted)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "A problem occurred when updating your points. Please check your internet connectivity")));
        return;
      }
      final activityOriginal = await firestore
          .collection(myNames.activitiesTable)
          .doc(activityID)
          .get();
      var originalPoints =
          activityOriginal.data()![myNames.members][email][myNames.points];
      originalPoints += 1;
      WriteBatch updatePoints = firestore.batch();
      //UPDATE THE POINTS IN THE ACTIVITY TO BE THE ORIGINAL POINTS +1  TO ALLOW
      //AUTOMATIC REPETITION OF THE ACTIVITY WHILE SAVING THE TOTAL AGGREGATED POINTS
      //IN THE ORIGINAL ACTIVITY
      updatePoints.set(
          firestore.collection(myNames.activitiesTable).doc(activityID),
          {
            myNames.members: {
              email: {myNames.points: originalPoints}
            }
          },
          SetOptions(merge: true));
      // await firestore.collection(myNames.activitiesTable).doc(activityID).set({
      //   myNames.members: {
      //     email: {
      //       myNames.points: activity[myNames.members][email][myNames.points]
      //     }
      //   }
      // }, SetOptions(merge: true));
      //UPDATE MY ACTIVITY IN THE USERS TABLE
      updatePoints.set(
          firestore.collection(myNames.usersTable).doc(docSnapshot.data!.id),
          {
            myNames.activities: {activityID: activity}
          },
          SetOptions(merge: true));
      // await firestore
      //     .collection(myNames.usersTable)
      //     .doc(docSnapshot.data!.id)
      //     .set({
      //   myNames.activities: {activityID: activity}
      // }, SetOptions(merge: true));
      await updatePoints.commit();
    } else {
      if (endTime.compareTo(clickedTime) <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Activity has ended! Check its report by refreshing the reports section.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Activity already checked for this " +
                (activity[myNames.activityRate] == 'Daily' ? "Day" : "Week"))));
      }
    }
  }

  String expandToListOfStrings(Map map) {
    String result = "";
    int count = 0;
    map.forEach((key, value) {
      result += map[key][myNames.name];
      if (count < map.length - 1) {
        result += ", ";
      }
      count++;
    });
    return result;
  }

  int dayFromTo(DateTime startTime, DateTime doneTime) {
    return doneTime.toUtc().difference(startTime.toUtc()).inDays;
  }
}
