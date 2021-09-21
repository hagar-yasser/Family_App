import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/myNames.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsBrief extends StatefulWidget {
  const ReportsBrief({Key? key}) : super(key: key);
  static const routeName = '/reportsBrief';

  @override
  _ReportsBriefState createState() => _ReportsBriefState();
}

class _ReportsBriefState extends State<ReportsBrief> {
  ScrollController _scrollController = ScrollController();
  Future<DocumentSnapshot> checkActivitiesStates(
      FirebaseFirestore firestore, String email) async {
    QuerySnapshot myQuery = await firestore
        .collection(myNames.usersTable)
        .where(myNames.email, isEqualTo: email)
        .limit(1)
        .get();
    DocumentSnapshot myDoc = myQuery.docs[0];
    String id = myDoc.id;
    Map activities = myDoc[myNames.activities];
    List activitiesIDs = [];
    activities.forEach((key, value) {
      activitiesIDs.add(key);
    });
    DateTime now = DateTime.now().toUtc();
    for (int i = 0; i < activitiesIDs.length; i++) {
      if (now.compareTo(
              activities[activitiesIDs[i]][myNames.endTime].toDate()) >
          0) {
        final internetCheck =
            await firestore.collection(myNames.usersTable).doc(id).get();
        if (internetCheck.metadata.isFromCache) {
          if (this.mounted)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "A problem occurred when updating your reports. Please check your internet connectivity")));
        } else {
          DocumentSnapshot activityOriginal = await firestore
              .collection(myNames.activitiesTable)
              .doc(activitiesIDs[i])
              .get();
          WriteBatch updateReports = firestore.batch();
          updateReports.set(
              firestore.collection(myNames.usersTable).doc(id),
              {
                myNames.activities: {activitiesIDs[i]: FieldValue.delete()},
              },
              SetOptions(merge: true));
          // await firestore.collection(myNames.usersTable).doc(id).set({
          //   myNames.activities: {activitiesIDs[i]: FieldValue.delete()}
          // }, SetOptions(merge: true));
          print(
              "activity original data: " + activityOriginal.data().toString());
          updateReports.set(
              firestore.collection(myNames.usersTable).doc(id),
              {
                myNames.reports: {
                  activitiesIDs[i]: (activityOriginal.data() as Map)
                }
              },
              SetOptions(merge: true));
          // await firestore.collection(myNames.usersTable).doc(id).set({
          //   myNames.reports: {
          //     activitiesIDs[i]: (activityOriginal.data() as Map)
          //   }
          // }, SetOptions(merge: true));
          updateReports.set(
              firestore
                  .collection(myNames.activitiesTable)
                  .doc(activitiesIDs[i]),
              {
                myNames.reportsSent: {myDoc[myNames.email]: true}
              },
              SetOptions(merge: true));
          // await firestore
          //     .collection(myNames.activitiesTable)
          //     .doc(activitiesIDs[i])
          //     .set({
          //   myNames.reportsSent: {myDoc[myNames.email]: true}
          // }, SetOptions(merge: true));
          await updateReports.commit();
        }
      }
    }
    return firestore.collection(myNames.usersTable).doc(id).get();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!;
    print("hello in reportsbrief build");
    return Scaffold(
      body: FutureBuilder(
        future: checkActivitiesStates(firestore, myEmail),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('An Error occurred when fetching reports'),
            );
          }
          Map? reports = (snapshot.data!.data()! as Map)[myNames.reports];
          List reportsIDs = [];
          if (reports != null) {
            reports.forEach((key, value) {
              reportsIDs.add(key);
            });
          }
          print(reportsIDs.length);

          return Center(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: (reportsIDs.length == 0)
                  ? ListView(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "There are no reports to show yet. Add an activity from the home page and when it finishes its report will appear here",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
                  : Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: true,
                      interactive: true,
                      showTrackOnHover: true,
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: reportsIDs.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                                  Expanded(
                                                    child: Text(
                                                        reports![reportsIDs[
                                                                index]]
                                                            [myNames.name],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ),
                                                  Text(
                                                      (reports[reportsIDs[index]]
                                                                          [myNames.members]
                                                                      [myEmail][
                                                                  myNames
                                                                      .points])
                                                              .toString() +
                                                          "/" +
                                                          (reports[reportsIDs[index]][myNames.reportRate] ==
                                                                      reports[reportsIDs[index]]
                                                                          [
                                                                          myNames
                                                                              .activityRate]
                                                                  ? 1
                                                                  : 7)
                                                              .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffAACDBE),
                                                          fontSize: 30)),
                                                  Expanded(
                                                    child: Container(
                                                      width: 200,
                                                      child: Text(
                                                        expandToListOfStrings(
                                                            (reports[reportsIDs[
                                                                    index]][
                                                                myNames
                                                                    .members])),
                                                        overflow: TextOverflow
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
                                                Navigator.of(context).pushNamed(
                                                    '/fullReport',
                                                    arguments: reports[
                                                        reportsIDs[index]]);
                                              },
                                              icon: Icon(Icons
                                                  .keyboard_arrow_right_rounded),
                                              iconSize: 40,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
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
        },
      ),
    );
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
}
