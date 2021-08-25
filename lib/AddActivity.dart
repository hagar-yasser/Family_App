import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late List<Map> _members;
  List<String> _reportDropDownList = ['Daily', "Weekly"];
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    User? user = Provider.of<Auth>(context, listen: false).getCurrentUser();
    _members = [
      {'name': user!.displayName, 'email': user.email}
    ];
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
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: Color(0xffF7A440),
                              size: 50,
                            )),
                        Expanded(
                            child: Center(
                          child: Text("Add Activity",
                              style: TextStyle(fontSize: 35)),
                        ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
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

                            if (chosen != null) {
                              List<Map> chosenList = (chosen as List<Map>);
                              setState(() {
                                _members = chosenList;
                              });
                            }
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
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Card(
                          color: Colors.white,
                          elevation: 8,
                          child: Scrollbar(
                            interactive: true,
                            showTrackOnHover: true,
                            child: ListView.separated(
                              itemCount: _members.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    _members[index]['name'],
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
                                _controller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please enter the activity name!')));
                            } else {
                              final userInDB = await firestore
                                  .collection('Users')
                                  .where('email', isEqualTo: user!.email)
                                  .get();
                              final updatedActivities =
                                  userInDB.docs[0]['activities'] as List;
                              final timeAdded = new DateTime.now().toUtc();
                              final endTime = timeAdded
                                  .add(new Duration(
                                      days:
                                          _reportRateValue == "Daily" ? 1 : 7))
                                  .toUtc();
                             
                              updatedActivities.add({
                                'name': _controller.text,
                                'points': 0,
                                'members': _members,
                                'activityRate': _activityRateValue,
                                'reportRate': _reportRateValue,
                                'timeAdded': timeAdded,
                                'endTime': endTime
                              });
                              await firestore
                                  .collection('Users')
                                  .doc(userInDB.docs[0].id)
                                  .update({'activities': updatedActivities});
                              Navigator.pop(context);
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
}
