import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MySmallRoundedButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:family_app/objects/Activity.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ActivityBrief extends StatelessWidget {
  const ActivityBrief({Key? key}) : super(key: key);
  static const routeName = '/activityBrief';

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
          if (snapshot.data!=null&&snapshot.data!.docs[0]['activities'].length == 0) {
            
            return Center();
          }
          return Center(
            child: Scrollbar(
              isAlwaysShown: true,
              interactive: true,
              showTrackOnHover: true,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: snapshot.data?.docs[0]['activities'].length?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var activities = snapshot.data?.docs[0]['activities'];
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text.rich(TextSpan(
                                              text: activities[index]['name'],
                                              style: TextStyle(fontSize: 20))),
                                          Text(
                                              activities[index]
                                                      ['percentage']
                                                      .toString() +
                                                  '%',
                                              style: TextStyle(
                                                  color: Color(0xffAACDBE),
                                                  fontSize: 30)),
                                          Container(
                                            width: 200,
                                            child: Text(
                                              expandListOfStrings(
                                                  (activities[index]['members'] as List<Map>)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      color: Color(0xffF7A440),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            '/fullActivity',
                                            arguments: activities[index]);
                                      },
                                      icon: Icon(
                                          Icons.keyboard_arrow_right_rounded),
                                      iconSize: 40,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            MySmallRoundedButton(
                              action: () {},
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
          );
        },
      ),
    );
  }

  static String expandListOfStrings(List<Map> list) {
    String result = "";
    for (int i = 0; i < list.length; i++) {
      result += list[i]['name'];
      if (i < list.length - 1) {
        result += ", ";
      }
    }
    return result;
  }
}
