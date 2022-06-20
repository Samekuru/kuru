// ignore_for_file: file_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuru/benimSebzeMeyvelerim.dart';
import 'package:kuru/home.dart';
import 'package:kuru/loginPage.dart';

import 'main.dart';

class AdminPage extends StatefulWidget {
  var user;

  AdminPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

TextEditingController _firstController = TextEditingController();
TextEditingController _secondController = TextEditingController();
TextEditingController _thirdController = TextEditingController();
PlatformFile? pickedFile;
UploadTask? uploadTask;
bool isUploading = false;

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const DeleteObject()),
            );
          },
          icon: const Icon(CupertinoIcons.delete),
        )
      ]),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pickedFile == null
                  ? OutlinedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles();
                        setState(() {
                          pickedFile = result!.files.first;
                        });
                      },
                      child: const Text('Resim Seç'),
                    )
                  : Image.file(
                      File(pickedFile!.path!),
                      width: width * 0.5,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.9,
                child: TextField(
                  controller: _firstController,
                  autocorrect: false,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon:
                        Icon(CupertinoIcons.bubble_left, color: Colors.grey),
                    labelText: 'Meyve Sebze Adı',
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
                  controller: _secondController,
                  autocorrect: false,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon:
                        Icon(CupertinoIcons.money_dollar, color: Colors.grey),
                    labelText: 'Kilo Fiyatı',
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
                  controller: _thirdController,
                  autocorrect: false,
                  enableSuggestions: true,
                  minLines: 3,
                  maxLines: 3,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon:
                        Icon(CupertinoIcons.command, color: Colors.grey),
                    labelText: 'Açıklama',
                    floatingLabelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isUploading
                  ? SizedBox(
                      width: width * 0.4,
                      child: const SizedBox(
                        height: 41,
                        width: 20,
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () async {
                        setState(() {
                          isUploading = true;
                        });
                        final path = pickedFile!.path.toString();
                        final file = File(pickedFile!.path!);
                        uploadTask = storageRef.child(path).putFile(file);
                        final snapshot =
                            await uploadTask!.whenComplete(() => null);
                        final url = await snapshot.ref.getDownloadURL();
                        bool? isAdmin;
                        await firestore.collection('users').doc(user1!.uid).get().then((snapshot) {
                          isAdmin = snapshot.data()!['isAdmin'];
                          return;
                        });
                        await firestore
                            .collection('urunler')
                            .doc()
                            .set({
                          'meyve-sebze-adi': _firstController.text,
                          'kilo-fiyati': _secondController.text,
                          'aciklama': _thirdController.text,
                          'uploaderUID': widget.user!.uid,
                          'imageUrl': url,
                          'time': DateTime.now(),
                          'isAdmin': isAdmin,
                        });
                        setState(() {
                          isUploading = false;
                        });
                      },
                      child: const Text('Yükle'),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      auth.signOut();
                      isLoginLoading = false;
                      isCreateLoading = false;
                    },
                    child: const Text('Çıkış Yap'),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () async {
                      firestore
                          .collection('users')
                          .doc(widget.user!.uid)
                          .delete();
                      firestore
                          .collection('users')
                          .doc(widget.user!.uid)
                          .collection('sebzemeyve')
                          .doc()
                          .delete();
                      auth.currentUser?.delete();
                      isLoginLoading = false;
                      isCreateLoading = false;
                    },
                    child: const Text('Hesabı Sil'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
