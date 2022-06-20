import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuru/bottomNavBar.dart';

import 'loginPage.dart';
import 'main.dart';
import 'waitingPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
User? user1;
class _HomeState extends State<Home> {
  String? page;
  
  @override
  void initState() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('user boş');
        setState(() {
          page = 'login';
        });
      } else {
        debugPrint('user boş değil');
        debugPrint(user.uid);
        user1 = user;
        setState(() {
          page = 'main';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case 'login':
        {
          return const LoginPage();
        }
      case 'main':
        {
          return const BottomNavBar();
        }
      default:
        {
          return const WaitingPage();
        }
    }
  }
}
