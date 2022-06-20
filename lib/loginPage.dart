// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kuru/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
bool isCreateLoading = false;
bool isLoginLoading = false;
bool value = false;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width),
          const Text(
            'Foods',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: width * 0.9,
            child: TextField(
              controller: _emailController,
              autocorrect: false,
              enableSuggestions: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                prefixIcon: Icon(CupertinoIcons.mail, color: Colors.grey),
                labelText: 'Email adresiniz',
                floatingLabelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: width * 0.9,
            child: TextField(
              controller: _passwordController,
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                prefixIcon: Icon(CupertinoIcons.lock, color: Colors.grey),
                labelText: 'Şifreniz',
                floatingLabelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isCreateLoading
                  ? SizedBox(
                      width: width * 0.4,
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : SizedBox(
                      width: width * 0.4,
                      child: OutlinedButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              isCreateLoading = true;
                            });
                            User? user =
                                (await auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ))
                                    .user;
                            await firestore
                                .collection('users')
                                .doc(user!.uid)
                                .set({
                              'userUid': user.uid,
                              'userEmail': user.email,
                              'userPassword': _passwordController.text,
                              'firstLogin': DateTime.now(),
                              'lastLogin': DateTime.now(),
                              'isAdmin': value,
                            });
                          } on FirebaseAuthException catch (e) {
                            debugPrint('toast message:${e.toString()}');
                            Fluttertoast.showToast(
                              msg: e.toString(),
                              gravity: ToastGravity.CENTER,
                            );
                            setState(() {
                              isCreateLoading = false;
                            });
                          }
                        },
                        child: const Text('Kayıt Ol'),
                      ),
                    ),
              SizedBox(width: width * 0.1),
              isLoginLoading
                  ? SizedBox(
                      width: width * 0.4,
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : SizedBox(
                      width: width * 0.4,
                      child: OutlinedButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoginLoading = true;
                            });
                            User? user = (await auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ))
                                .user;
                            await firestore
                                .collection('users')
                                .doc(user!.uid)
                                .update({
                              'lastLogin': DateTime.now(),
                            });
                          } on FirebaseAuthException catch (e) {
                            debugPrint('toast message:${e.toString()}');
                            Fluttertoast.showToast(
                              msg: e.toString(),
                              gravity: ToastGravity.CENTER,
                            );
                            setState(() {
                              isLoginLoading = false;
                            });
                          }
                        },
                        child: const Text('Giriş Yap'),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
