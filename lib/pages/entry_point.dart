import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/favourite_page.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:weather_app/constants.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        children: [
          HomePage(),
          FavouritePage(),
          HomePage(),
        ],
        index: _selectedIndex,
      ),
      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      //   child: Theme(
      //     child: BottomNavigationBar(
      //       backgroundColor: bottomNavBarColor,
      //       showSelectedLabels: false,
      //       showUnselectedLabels: false,
      //       selectedItemColor: selectedHomeColor,
      //       unselectedItemColor: Colors.grey,
      //       currentIndex: _selectedIndex,
      //       onTap: _onItemTapped,
      //       elevation: 0,
      //       iconSize: 25,
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(
      //             CupertinoIcons.house_fill,
      //           ),
      //           label: '',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(
      //             CupertinoIcons.heart_solid,
      //           ),
      //           label: '',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(
      //             Icons.settings_rounded,
      //             size: 27,
      //           ),
      //           label: '',
      //         ),
      //       ],
      //     ),
      //     data: ThemeData(
      //       splashColor: Colors.transparent,
      //       highlightColor: Colors.transparent,
      //     ),
      //   ),
      //   decoration: BoxDecoration(
      //     color: bottomNavBarColor,
      //     borderRadius: BorderRadius.circular(30),
      //     boxShadow: [BoxShadow(
      //       offset: Offset.zero,
      //       blurRadius: 10,
      //       color: Colors.white10,
      //       spreadRadius: 1
      //     )],
      //   ),
      // ),
    );
  }
}
