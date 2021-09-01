import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMembersWrapper extends StatelessWidget {
  static const routeName = '/addMembers';
  const AddMembersWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!.replaceAll('.', '_');
    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: firestore
                .collection('Users')
                .where('email', isEqualTo: myEmail)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return AddMembers(snapshot:snapshot);
            }));
  }
}

class AddMembers extends StatefulWidget {
  
  final AsyncSnapshot<QuerySnapshot> snapshot;
  const AddMembers({Key? key,required this.snapshot}) : super(key: key);

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  late Map _chosenMembers;
  late String myEmail;
  void initState() {
    super.initState();
    User? user = Provider.of<Auth>(context, listen: false).getCurrentUser();
    myEmail = user!.email!.replaceAll('.', '_');
    _chosenMembers = {
      myEmail: {'name': user.displayName, 'points': 0}
    };
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    final Map family = widget.snapshot.data!.docs[0]['family'];
    final List familyEmailsList = [];
    family.forEach((key, value) {
      familyEmailsList.add(key);
    });
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Scrollbar(
        interactive: true,
        showTrackOnHover: true,
        child: ListView(
          children: [
            Column(
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
                      child: Text("Add Members",
                          style: TextStyle(fontSize: 35)),
                    ))
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: (widget.snapshot.data == null ||
                          familyEmailsList.length == 0)
                      ? Center()
                      : Scrollbar(
                          interactive: true,
                          showTrackOnHover: true,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: familyEmailsList.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return GestureDetector(
                                child: Card(
                                  color: _chosenMembers[
                                              familyEmailsList[index]] !=
                                          null
                                      ? Color(0xffEA907A)
                                      : Colors.white,
                                  elevation: 8,
                                  child: Text(
                                    family[familyEmailsList[index]]
                                        ['name'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (_chosenMembers[
                                            familyEmailsList[index]] !=
                                        null) {
                                      _chosenMembers.remove(
                                          familyEmailsList[index]);
                                    } else {
                                      _chosenMembers[
                                              familyEmailsList[index]] =
                                          family[familyEmailsList[index]];
                                      _chosenMembers[
                                              familyEmailsList[index]]
                                          ['points'] = 0;
                                    }
                                  });
                                },
                              );
                            },
                          )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  
      
    
  }
}