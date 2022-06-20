// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuru/adminPage.dart';
import 'package:kuru/home.dart';
import 'package:kuru/mainPage.dart';
import 'package:kuru/searchPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController pageViewController = PageController(initialPage: 0);
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        pageSnapping: true,
        onPageChanged: (int page) => {
          setState(() {
            currentIndex = page;
          }),
        },
        children: [
          MainPage(user: user1),
          const SearchPage(),
          AdminPage(user: user1),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, color: Colors.white30),
            activeIcon: Icon(CupertinoIcons.home, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search, color: Colors.white30),
            activeIcon: Icon(CupertinoIcons.search, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person, color: Colors.white30),
            activeIcon: Icon(CupertinoIcons.person, color: Colors.white),
            label: '',
          ),
        ],
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            pageViewController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            currentIndex = index;
          });
        },
      ),
    );
  }
}
