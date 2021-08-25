import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/Profile.dart';
import 'package:family_app/Reports.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // User? user = Provider.of<Auth>(context).getCurrentUser();
    // Provider.of<Auth>(context).checkIfUserAddedToDB(user!);
    return Scaffold(
      body: currentPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
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
        return Reports();
      case 2:
        return Profile();

      default:
        return ActivityBrief();
      // ActivityBrief(
      //     activ: Activity('Eating together', 70,
      //         ['Eman Ahmed', 'Omar Yasser', 'Yasser AbdelRaouf'], 1, 1));
    }
  }
}
