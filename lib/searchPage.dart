// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuru/main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

TextEditingController _searchController = TextEditingController();
String? kelime;
String? searchWord;

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: width,
                color: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.8,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => {kelime = val},
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            labelText: 'Ne Almak İstersiniz',
                            hintStyle: TextStyle(color: Colors.white24),
                            floatingLabelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.search),
                          onPressed: () {
                            setState(() {
                              searchWord = kelime;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              searchWord != null
                  ? FutureBuilder(
                      future: firestore
                          .collection('urunler')
                          .where('meyve-sebze-adi',
                              isGreaterThanOrEqualTo: searchWord)
                          .where('meyve-sebze-adi', isLessThan: '${searchWord!}z')
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                title: Text(
                                  snapshot.data.docs[index]['meyve-sebze-adi'],
                                ),
                                trailing: Text(
                                  '${snapshot.data.docs[index]['kilo-fiyati']}\$',
                                ),
                              );
                            }),
                          );
                        } else {
                          return const Text('HERE');
                        }
                      },
                    )
                  : Container(),
              // FutureBuilder(
              //   future: firestore
              //       .collection('users')
              //       .where('meyve-sebze-adi', isEqualTo: 'asdasd')
              //       .get(),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     return Card(
              //       child: Text('${snapshot.data()['kilo-fiyati']}'),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
