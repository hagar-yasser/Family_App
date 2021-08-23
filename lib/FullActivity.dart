import 'package:family_app/MySmallRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:google_fonts/google_fonts.dart';

class FullActivity extends StatelessWidget {
  static const routeName = '/fullActivity';
  
  const FullActivity({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context) {
   final activity = ModalRoute.of(context)!.settings.arguments as Activity;
   final ScrollController _controllerOne = ScrollController();
  
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
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
                SizedBox(
                  width: 270,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Scrollbar(
                      interactive: true,
                      
                      showTrackOnHover: true,
                     
                      controller: _controllerOne,
                      child: ListView(
                        controller: _controllerOne,
                        scrollDirection: Axis.horizontal,
                        children: [
                           Text(activity.name, style: TextStyle(fontSize: 35))
                        ],
                        
                        ),
                    ),
                  ),
                )
                       
              ],
            ),
            Text(activity.percentage.toString() + '%',
                style: TextStyle(color: Color(0xffAACDBE), fontSize: 30)),
            Text('Members', style: TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListOfMembers(activity),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: 'Activity Rate: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextSpan(
                      text: 'Daily',
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextSpan(text: 'Weekly', style: TextStyle(fontSize: 20))
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MySmallRoundedButton(
                      action: () {},
                      child: Icon(Icons.check),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MySmallRoundedButton(
                      action: () {},
                      child: Icon(Icons.close),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListOfMembers extends StatelessWidget {
  final Activity activity;
  const ListOfMembers(this.activity);

  @override
  Widget build(BuildContext context) {
     final ScrollController _controllerTwo = ScrollController();
    return Container(
      height: 200,
      width: 200,
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Scrollbar(
          interactive: true,
          isAlwaysShown: true,
          showTrackOnHover: true,
          controller: _controllerTwo,
          child: ListView.separated(
            itemCount: activity.members.length,
            controller: _controllerTwo,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  activity.members[index],
                  style: TextStyle(fontSize: 20),
                ),
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
