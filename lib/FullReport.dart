import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/MySmallRoundedButton.dart';
import 'package:family_app/myNames.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'authorization/Auth.dart';

class FullReport extends StatelessWidget {
  static const routeName = '/fullReport';

  const FullReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activity = ModalRoute.of(context)!.settings.arguments as Map;
    final ScrollController _controllerOne = ScrollController();
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!;
    int maxPoints = 0;
    DateTime timeAdded = (activity[myNames.timeAdded]).toDate();
    DateTime endTime = (activity[myNames.endTime]).toDate();
    if (activity[myNames.activityRate] == 'Daily') {
      maxPoints = endTime.difference(timeAdded).inDays;
    } else {
      maxPoints = endTime.difference(timeAdded).inDays ~/ 7;
    }
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Scrollbar(
        interactive: true,
        showTrackOnHover: true,
        child: Center(
            child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      activity[myNames.name],
                      style: TextStyle(fontSize: 35),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )
                  // SizedBox(
                  //   width: 270,
                  //   height: 80,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Scrollbar(
                  //       interactive: true,
                  //       showTrackOnHover: true,
                  //       controller: _controllerOne,
                  //       child: ListView(
                  //         controller: _controllerOne,
                  //         scrollDirection: Axis.horizontal,
                  //         children: [
                  //           Text(activity[myNames.name],
                  //               style: TextStyle(fontSize: 35))
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Text(
                  "End Time: " +
                      displayTime(activity[myNames.endTime].toDate()),
                  style: TextStyle(color: Color(0xffAACDBE), fontSize: 20)),
              Text('Members', style: TextStyle(fontSize: 30)),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListOfMembersReport(
                    activity[myNames.members],
                    //CHANGE MAX POINTS TO BE THE NUMBER OF OCCURENCES OF THE ACTIVITY
                    // (activity[myNames.reportRate] ==
                    //         activity[myNames.activityRate]
                    //     ? 1
                    //     : 7)
                    maxPoints),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: 'Activity Rate: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    TextSpan(
                        text: activity[myNames.activityRate],
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: 'Report Rate: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    TextSpan(
                        text: activity[myNames.reportRate],
                        style: TextStyle(fontSize: 20))
                  ]),
                ),
              ),
            ],
          ),
        ])),
      ),
    );
  }

  String displayTime(DateTime time) {
    String res = "";
    res += "${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}";
    return res;
  }
}

class ListOfMembersReport extends StatelessWidget {
  final Map members;
  final int maxPoints;
  const ListOfMembersReport(this.members, this.maxPoints);

  @override
  Widget build(BuildContext context) {
    final ScrollController _controllerTwo = ScrollController();
    List membersList = [];
    members.forEach((key, value) {
      membersList.add(key);
    });
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 200, maxWidth: 200, minHeight: 0, maxHeight: 200),
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Scrollbar(
          interactive: true,
          isAlwaysShown: true,
          showTrackOnHover: true,
          controller: _controllerTwo,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: membersList.length,
            controller: _controllerTwo,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  members[membersList[index]][myNames.name],
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Text(
                    (members[membersList[index]][myNames.points]).toString() +
                        '/' +
                        maxPoints.toString(),
                    style: TextStyle(color: Color(0xffAACDBE), fontSize: 30)),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }
}
