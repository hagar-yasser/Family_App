import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMembers extends StatefulWidget {
  static const routeName = '/addMembers';
  const AddMembers({Key? key}) : super(key: key);

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  List<Map> _chosenMembers = [];
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: firestore.collection('Users').where('email',isEqualTo: user!.email).get(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //        if (snapshot.hasError) {
        //   return Text("Something went wrong");
        // }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Scrollbar(
              interactive: true,
              showTrackOnHover: true,
              child: ListView(
                children: [Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context, _chosenMembers);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: Color(0xffF7A440),
                              size: 50,
                            )),
                        Expanded(
                            child: Center(
                          child:
                              Text("Add Members", style: TextStyle(fontSize: 35)),
                        ))
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: (snapshot.data == null ||
                              snapshot.data!.docs[0]['friends'].length == 0)
                          ? Center()
                          : Scrollbar(
                              interactive: true,
                              showTrackOnHover: true,
                              child: ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemCount: snapshot.data!.docs[0]['friends'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Card(
                                      color: _chosenMembers.contains(
                                              snapshot.data!.docs[0]['friends'][index])
                                          ? Color(0xffEA907A)
                                          : Colors.white,
                                      elevation: 8,
                                      child: Text(
                                        snapshot.data!.docs[0]['friends'][index].name,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (_chosenMembers.contains(
                                            snapshot.data!.docs[0]['friends'][index])) {
                                          _chosenMembers.remove(
                                              snapshot.data!.docs[0]['friends'][index]);
                                        } else {
                                          _chosenMembers.add(
                                              snapshot.data!.docs[0]['friends'][index]);
                                        }
                                      });
                                    },
                                  );
                                },
                              )),
                    ),
                  ],
                )],
              ),
            ),
          );
        },
      ),
    );
  }
}
