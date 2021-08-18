import 'package:flutter/material.dart';
import './FullActivity.dart';
import './objects/Activity.dart';
import './FullActivity.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityBrief extends StatelessWidget {
  final Activity activity;
  const ActivityBrief({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scrollbar(
          isAlwaysShown: true,
          interactive: true,
          showTrackOnHover: true,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 200,
                width: 300,
                child: Card(
                  color:Colors.white,
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(32, 8.0, 8.0, 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text.rich(TextSpan(
                                          text: activity.name,
                                          style: TextStyle(fontSize: 20))),
                                      Text(activity.percentage.toString() + '%',
                                          style: TextStyle(
                                              color: Color(0xffAACDBE),
                                              fontSize: 30)),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          expandListOfStrings(activity.members),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    color: Color(0xffF7A440),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullActivity(activity)));
                                    },
                                    icon: Icon(Icons.keyboard_arrow_right_rounded),iconSize: 40,)
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: Icon(Icons.check),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue),
                            ))))
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
  }

  static String expandListOfStrings(List<String> list) {
    String result = "";
    for (int i = 0; i < list.length; i++) {
      result += list[i];
      if (i < list.length - 1) {
        result += ", ";
      }
    }
    return result;
  }
}
