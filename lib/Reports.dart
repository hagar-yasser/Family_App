import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);
  static const routeName = '/reports';

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  ScrollController _scrollController = ScrollController();
  Future<DocumentSnapshot> checkActivitiesStates(
      FirebaseFirestore firestore, String email) async {
    QuerySnapshot myQuery = await firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    DocumentSnapshot myDoc = myQuery.docs[0];
    String id = myDoc.id;
    Map activities = myDoc['activities'];
    List activitiesIDs = [];
    activities.forEach((key, value) {
      activitiesIDs.add(key);
    });
    DateTime now = DateTime.now().toUtc();
    for (int i = 0; i < activitiesIDs.length; i++) {
      if (now.compareTo(activities[activitiesIDs[i]]['endTime'].toDate()) > 0) {
        DocumentSnapshot activityOriginal = await firestore
            .collection('Activities')
            .doc(activitiesIDs[i])
            .get();
        Map members = activityOriginal['members'];
        await firestore
            .collection('Users')
            .doc(id)
            .update({'activities.' + activitiesIDs[i]: FieldValue.delete()});
        await firestore
            .collection('Users')
            .doc(id)
            .update({'reports.' + activitiesIDs[i]: members});
        await firestore
            .collection('Activities')
            .doc(activitiesIDs[i])
            .update({'reportsSent.' + myDoc['email']: true});
      }
    }
    return firestore.collection('Users').doc(id).get();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!.replaceAll('.', '_');
    return FutureBuilder(
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
        Map? reports = (snapshot.data!.data()! as Map)['reports'];
        List reportsIDs = [];
        if (reports != null) {
          reports.forEach((key, value) {
            reportsIDs.add(key);
          });
        }
        return Center(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              interactive: true,
              showTrackOnHover: true,
              child: ListView.separated(
                controller: _scrollController,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: reportsIDs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
