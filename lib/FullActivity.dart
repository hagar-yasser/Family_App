import 'package:flutter/material.dart';
import './objects/Activity.dart';
import 'package:google_fonts/google_fonts.dart';


class FullActivity extends StatelessWidget {
  final Activity activity;
  const FullActivity(this.activity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: IconButton(
                    onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.keyboard_arrow_left_rounded,color: Color(0xffF7A440),size: 50,)),
                )
                ,Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Text(activity.name,style:  TextStyle(fontSize: 40))),
              ],
            ),
            Text(activity.percentage.toString() + '%',
                style: TextStyle(color: Color(0xffAACDBE),fontSize: 30)
                ),
            Text('Members',style: TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListOfMembers(activity),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                  TextSpan(
                  children: [
                    TextSpan(
                      text: 'Activity Rate: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                    TextSpan(
                      text: 'Daily',
                      style: TextStyle(
                        fontSize: 20,
                       
                        ))
                  ]
              ),),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                 TextSpan(
                  children: [
                    TextSpan(text: 'Report Rate: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    TextSpan(text: 'Weekly',style: TextStyle(fontSize: 20))
                  ]
              ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){}, 
                        child: Icon(Icons.check),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue),
                              
                            )
                          )
                      )
                        ),
                    ),
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (){}, 
                        child: Icon(Icons.close),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xffEA907A)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              // side: BorderSide(color: Colors.red),
                              
                            )
                          )
                      )
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
    return  Container(
        height: 200,
        width: 200,
        child: Card(
          color: Colors.white,
          elevation: 8,
          child: Scrollbar(
            interactive: true,
            isAlwaysShown: true,
            showTrackOnHover: true,
            child:
             ListView.separated(
                itemCount: activity.members.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(activity.members[index],style: TextStyle(fontSize: 20),),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
          ),
        ),
      
    );
  }
}

