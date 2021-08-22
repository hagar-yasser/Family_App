import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/Profile.dart';
import 'package:family_app/objects/Activity.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: currentPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        return ActivityBrief(
            activ: Activity('Eating together', 70,
                ['Eman Ahmed', 'Omar Yasser', 'Yasser AbdelRaouf'], 1, 1));
      case 1:
        return Profile();
        
      default:
        return  ActivityBrief(
            activ: Activity('Eating together', 70,
                ['Eman Ahmed', 'Omar Yasser', 'Yasser AbdelRaouf'], 1, 1));
    }
  }
}
