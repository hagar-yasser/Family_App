import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);
  static const routeName = '/reports';

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  Future<void> checkActivitiesStates(FirebaseFirestore firestore, id) async {
    DocumentSnapshot myDoc = await firestore.collection('Users').doc(id).get();
    List activities = myDoc['activities'];
    List reports = myDoc['reports'] == null ? [] : myDoc['reports'];
    DateTime now = DateTime.now().toUtc();
    for (int i = 0; i < activities.length; i++) {
      if (now.compareTo(activities[i]['endTime'].toDate()) > 0) {
        List scores = [];
        scores.add({
          myDoc['email']: (activities[i]['points']).toString() +
              '/' +
              (activities[i]['reportRate'] == activities[i]['activityRate']
                      ? 1
                      : 7)
                  .toString()
        });
        List members = activities[i]['members'];
        // first member is me
        List docIdsOfMembers = [];
        List reportsOfMembers = [];
        for (int i = 1; i < members.length; i++) {
          QuerySnapshot myQuery = await firestore
              .collection("Users")
              .where('email', isEqualTo: members[i]['email'])
              .get();
          docIdsOfMembers.add(myQuery.docs[0].id);
          reportsOfMembers.add(myQuery.docs[0]['reports']);
          List activitiesOfMember = myQuery.docs[0]['activities'];
          Map myActivity = activitiesOfMember
              .firstWhere((element) => element['id'] == activities[i]['id']);
          scores.add({
            members[i]['email']: (myActivity['points']).toString() +
                '/' +
                (myActivity['reportRate'] == myActivity['activityRate'] ? 1 : 7)
                    .toString()
          });
        }
        reports.add({'activity': activities[i], 'scores': scores});
        for (int i = 0; i < docIdsOfMembers.length; i++) {
          reportsOfMembers[i]
              .add({'activity': activities[i], 'scores': scores});
          await firestore
              .collection('User')
              .doc(docIdsOfMembers[i])
              .update({'reports': reportsOfMembers[i]});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
