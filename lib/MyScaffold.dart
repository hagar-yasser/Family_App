import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/Family.dart';
import 'package:family_app/Profile.dart';
import 'package:family_app/ReportsBrief.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/database/MyDocument.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyScaffoldWrapper extends StatelessWidget {
  const MyScaffoldWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!.replaceAll('.', '_');
    return FutureBuilder(
        future: firestore
            .collection('Users')
            .where('email', isEqualTo: myEmail)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occured when loading user data'),
            );
          }
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
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
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = Provider.of<Auth>(context).getCurrentUser();
    String myEmail = user!.email!.replaceAll('.', '_');
    return Scaffold(
      body: currentPage(_selectedIndex),
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
