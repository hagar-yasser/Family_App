import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/Family.dart';
import 'package:family_app/Profile.dart';
import 'package:family_app/ReportsBrief.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/database/MyDocument.dart';
import 'package:family_app/myNames.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyScaffoldWrapper extends StatefulWidget {
  const MyScaffoldWrapper({Key? key}) : super(key: key);

  @override
  _MyScaffoldWrapperState createState() => _MyScaffoldWrapperState();
}

class _MyScaffoldWrapperState extends State<MyScaffoldWrapper> {
  late final myUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    User? user = Provider.of<Auth>(context, listen: false).getCurrentUser();
    String myEmail = user!.email!;
    myUser = firestore
        .collection(myNames.usersTable)
        .where(myNames.email, isEqualTo: myEmail)
        .limit(1)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!;
    return FutureBuilder(
        future: myUser,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Text('An error occured when loading user data'),
              ),
            );
          }
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          Provider.of<MyDocument>(context).id = snapshot.data!.docs[0].id;
          return MyScaffold();
        });
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({
    Key? key,
  }) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  late int _selectedIndex;
  final List<Widget> screens = [
    ActivityBrief(),
    ReportsBrief(),
    Family(),
    Profile()
  ];
  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    print('hey there');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'Family',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget currentPage(int index) {
    switch (index) {
      case 0:
        return ActivityBrief();
      // ActivityBrief(
      //     activ: Activity('Eating together', 70,
      //         ['Eman Ahmed', 'Omar Yasser', 'Yasser AbdelRaouf'], 1, 1));
      case 1:
        return ReportsBrief();
      case 2:
        return Family();
      case 3:
        return Profile();

      default:
        return ActivityBrief();
      // ActivityBrief(
      //     activ: Activity('Eating together', 70,
      //         ['Eman Ahmed', 'Omar Yasser', 'Yasser AbdelRaouf'], 1, 1));
    }
  }
}
