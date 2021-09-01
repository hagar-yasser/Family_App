import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/MySmallRoundedButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/database/MyDocument.dart';
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

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!.replaceAll('.', '_');
    String? id = Provider.of<MyDocument>(context).id;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber[800],
          onPressed: () {
            Navigator.of(context).pushNamed('/addActivity');
          },
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: firestore.collection('Users').doc(id).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> docSnapshot) {
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
              return Center(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    interactive: true,
                    showTrackOnHover: true,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: docSnapshot.data!['activities'].length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Map activities = docSnapshot.data!['activities'];
                        List activitiesIDs = [];
                        activities.forEach((key, value) {
                          activitiesIDs.add(key);
                        });
                        Map members =
                            activities[activitiesIDs[index]]['members'] as Map;
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
                                                Text(
                                                    activities[activitiesIDs[
                                                        index]]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                Text(
                                                    (activities[activitiesIDs[index]]
                                                                        ['members']
                                                                    [myEmail]
                                                                ['points'])
                                                            .toString() +
                                                        "/" +
                                                        (activities[activitiesIDs[index]]
                                                                        [
                                                                        'reportRate'] ==
                                                                    activities[
                                                                            activitiesIDs[index]]
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
                                                    expandToListOfStrings(
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
                                                          arguments: activities[
                                                              activitiesIDs[
                                                                  index]]);
                                              print(actionInsideFullActivity);
                                              if (actionInsideFullActivity !=
                                                  null) {
                                                if (actionInsideFullActivity ==
                                                    "Done") {
                                                  checkActivityDone(
                                                      activities[
                                                          activitiesIDs[index]],
                                                      activitiesIDs[index],
                                                      myEmail,
                                                      firestore,
                                                      docSnapshot);
                                                } else {
                                                  //REMOVE ME FROM THE LIST OF MEMBERS OF THIS ACTIVITY IN THE ACTIVITIES TABLE
                                                  await firestore
                                                      .collection('Activities')
                                                      .doc(activitiesIDs[index])
                                                      .update({
                                                    'members.' + myEmail:
                                                        FieldValue.delete()
                                                  });
                                                  //REMOVE THIS ACTIVITY FROM MY ACTIVITIES IN THE USER TABLE
                                                  activities.remove(
                                                      activitiesIDs[index]);
                                                  await firestore
                                                      .collection("Users")
                                                      .doc(docSnapshot.data!.id)
                                                      .update({
                                                    'activities.' +
                                                            activitiesIDs[
                                                                index]:
                                                        FieldValue.delete()
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
                                      await checkActivityDone(
                                          activities[activitiesIDs[index]],
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
    DateTime? lastDone =
        (activity['lastDone']) == null ? null : (activity['lastDone']).toDate();
    DateTime timeAdded = (activity['timeAdded']).toDate();
    DateTime endTime = (activity['endTime']).toDate();
    if (endTime.compareTo(clickedTime) > 0 &&
        (lastDone == null ||
            (activity['activityRate'] == 'Daily' &&
                dayFromTo(timeAdded, lastDone) !=
                    dayFromTo(timeAdded, clickedTime)))) {
      final previousPoints = activity['members'][email]['points'];
      activity['members'][email]['points'] = previousPoints + 1;
      activity['lastDone'] = clickedTime;
      //UPDATE THE ACTIVITY.ID IN THE ACTIVITIES TABLE WITH MY POINTS
      await firestore.collection('Activities').doc(activityID).update({
        'members.' + email + '.points': activity['members'][email]['points']
      });
      //UPDATE MY ACTIVITY IN THE USERS TABLE
      await firestore
          .collection("Users")
          .doc(docSnapshot.data!.id)
          .update({'activities.' + activityID: activity});
    } else {
      if (endTime.compareTo(clickedTime) <= 0) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Activity has ended! Check its report in the reports section.")));
      
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Activity already checked for this " +
                (activity['activityRate'] == 'Daily' ? "Day" : "Week"))));
      }
    }
  }

  String expandToListOfStrings(Map map) {
    String result = "";
    int count = 0;
    map.forEach((key, value) {
      result += map[key]['name'];
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
