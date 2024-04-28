import 'package:crud/view/profilepage.dart';
import 'package:crud/view/user/employee_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavigationWrapperUser extends StatefulWidget {
  @override
  _NavigationWrapperUserState createState() => _NavigationWrapperUserState();
}

class _NavigationWrapperUserState extends State<NavigationWrapperUser> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    EmployeeListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}