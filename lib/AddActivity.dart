import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:family_app/MyRectangularButton.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/myNames.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);
  static const routeName = '/addActivity';
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  TextEditingController _controller = TextEditingController();
  String _activityRateValue = "Daily";
  String _reportRateValue = "Daily";
  late Map _members;
  late String myEmail;
  List<String> _reportDropDownList = ['Daily', "Weekly"];
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    User? user = Provider.of<Auth>(context, listen: false).getCurrentUser();
    myEmail = user!.email!;
    _members = {
      myEmail: {myNames.name: user.displayName, myNames.points: 0}
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();

    return Scaffold(
      body: Scrollbar(
        interactive: true,
        showTrackOnHover: true,
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_left_rounded,
                                  color: Color(0xffF7A440),
                                  size: 50,
                                )),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Add Activity",
                            style: TextStyle(fontSize: 35),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        )

                        // Expanded(
                        //     child: Center(
                        //   child: Text("Add Activity",
                        //       style: TextStyle(fontSize: 35)),
                        // ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.deny(
                          //       RegExp(r'[.\\\[\]\*\`]'),
                          //       replacementString: ' ')
                          // ],
                          controller: _controller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Activity Name"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0.0),
                      child: ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            var chosen = await Navigator.of(context)
                                .pushNamed('/addMembers');
                            Map chosenMap = (chosen as Map);
                            setState(() {
                              _members = chosenMap;
                            });
                          },
                          label: Text('Add Members'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xffEA907A)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: 300,
                            maxWidth: 300,
                            minHeight: 0,
                            maxHeight: 200),
                        // height: 200,
                        // width: 300,
                        child: Card(
                          color: Colors.white,
                          elevation: 8,
                          child: Scrollbar(
                            interactive: true,
                            showTrackOnHover: true,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _members.length,
                              itemBuilder: (BuildContext context, int index) {
                                final List membersEmailsList = [];
                                _members.forEach((key, value) {
                                  membersEmailsList.add(key);
                                });
                                return ListTile(
                                  title: Text(
                                    //members is a map not a list
                                    _members[membersEmailsList[index]]
                                        [myNames.name],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Activity Rate: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          DropdownButton<String>(
                            value: _activityRateValue,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xffEA907A),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Color(0xffEA907A), fontSize: 20),
                            underline: Container(
                              height: 2,
                              color: Color(0xffEA907A),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _activityRateValue = newValue!;
                                if (_activityRateValue == "Weekly") {
                                  _reportRateValue = "Weekly";
                                  _reportDropDownList = ["Weekly"];
                                } else {
                                  _reportDropDownList = ["Daily", "Weekly"];
                                }
                              });
                            },
                            items: <String>['Daily', 'Weekly']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Report Rate: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          DropdownButton<String>(
                            value: _reportRateValue,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xffEA907A),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Color(0xffEA907A), fontSize: 20),
                            underline: Container(
                              height: 2,
                              color: Color(0xffEA907A),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _reportRateValue = newValue!;
                              });
                            },
                            items: _reportDropDownList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: MyRoundedLoadingButton(
                          action: () async {
                            if (_controller.text == null ||
                                _controller.text.isEmpty ||
                                (_controller.text
                                    .replaceAll(' ', '')
                                    .isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please enter the activity name!')));
                            } else {
                              final timeAdded = new DateTime.now().toUtc();
                              final endTime = timeAdded
                                  .add(new Duration(
                                      days:
                                          _reportRateValue == "Daily" ? 1 : 7))
                                  .toUtc();
                              //add the activity to the activity Collection
                              final newActivity = {
                                myNames.name: _controller.text,
                                myNames.members: _members,
                                myNames.activityRate: _activityRateValue,
                                myNames.reportRate: _reportRateValue,
                                myNames.timeAdded: timeAdded,
                                myNames.endTime: endTime
                              };
                              bool err = false;
                              late final internetCheck;
                              try {
                                internetCheck = await firestore
                                    .collection(myNames.usersTable)
                                    .doc(user!.uid)
                                    .get();
                              } on Exception catch (e) {
                                err = true;
                                _showErrorDialog(context,
                                    'A problem occured when loading your info. Please check your internet connection.');
                              }
                              if (err || internetCheck.metadata.isFromCache) {
                                if (this.mounted)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "A problem occurred when adding the activity. Please check your internet connectivity")));
                                if (this.mounted) Navigator.pop(context);
                              } else {
                                WriteBatch addActivity =
                                    FirebaseFirestore.instance.batch();
                                final newActivityRef = firestore
                                    .collection(myNames.activitiesTable)
                                    .doc();
                                addActivity.set(newActivityRef, newActivity);
                                // final activityRef = await firestore
                                //     .collection(myNames.activitiesTable)
                                //     .add(newActivity);
                                final activityID = newActivityRef.id;
                                final List<String?> tokens = [];
                                bool err = false;
                                for (MapEntry<dynamic, dynamic> m
                                    in _members.entries) {
                                  var key = m.key;
                                  var member;
                                  try {
                                    member = await firestore
                                        .collection(myNames.usersTable)
                                        .where(myNames.email, isEqualTo: key)
                                        .limit(1)
                                        .get();
                                  } on Exception catch (e) {
                                    err = true;
                                    _showErrorDialog(context,
                                        'A problem occured when loading the activity members info. Please check your internet connection.');
                                    break;
                                  }
                                  DocumentSnapshot myMember = member.docs[0];
                                  //Add its token to token array that will be sent to the cloud
                                  //function that will send notifications to other users
                                  // print(
                                  //     (myMember.data()! as Map)[myNames.token]);
                                  if (key != myEmail) {
                                    tokens.add((myMember.data()!
                                        as Map)[myNames.token]);
                                  }
                                  addActivity.set(
                                      firestore
                                          .collection(myNames.usersTable)
                                          .doc(myMember.id),
                                      {
                                        myNames.activities: {
                                          activityID: newActivity
                                        }
                                      },
                                      SetOptions(merge: true));
                                  // await firestore
                                  //     .collection(myNames.usersTable)
                                  //     .doc(myMember.id)
                                  //     .set({
                                  //   myNames.activities: {
                                  //     activityID: newActivity
                                  //   }
                                  // }, SetOptions(merge: true));
                                }
                                if (!err) {
                                  try {
                                    await addActivity.commit();
                                  } on Exception catch (e) {
                                    _showErrorDialog(context,
                                        'An error occured when adding the activity, check your internet connection.');
                                  }

                                  print(tokens.toString());
                                  FirebaseFunctions functions =
                                      FirebaseFunctions.instance;
                                  HttpsCallable notifyMembersNewActivity =
                                      FirebaseFunctions.instanceFor(
                                              region: "europe-west2")
                                          .httpsCallable(
                                              'notifyMembersNewActivity');
                                  try {
                                    Map data = {
                                      "name": user!.displayName,
                                      'activityName': newActivity[myNames.name],
                                      'tokens': tokens
                                    };
                                    await notifyMembersNewActivity.call(data);
                                  } on Exception catch (e) {
                                    print(e.toString());
                                  }
                                }
                              }
                              //call the cloud function that will send notifications

                            }
                          },
                          child: Text("Add")),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title) {
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
              children: <Widget>[],
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
