import 'package:family_app/MySmallRoundedButton.dart';
import 'package:flutter/material.dart';

import 'package:family_app/objects/Activity.dart';

import 'package:google_fonts/google_fonts.dart';

class ActivityBrief extends StatelessWidget {
  final activ;
  const ActivityBrief({Key? key, Activity? activ})
      : this.activ = activ,
        super(key: key);
  static const routeName = '/activityBrief';

  @override
  Widget build(BuildContext context) {
    final Activity activity = this.activ != null
        ? this.activ
        : ModalRoute.of(context)!.settings.arguments as Activity;
    
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
                  color: Colors.white,
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(32, 8.0, 8.0, 4.0),
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
                                    Navigator.of(context).pushNamed(
                                         '/fullActivity',
                                        arguments: activity);
                                  },
                                  icon:
                                      Icon(Icons.keyboard_arrow_right_rounded),
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
