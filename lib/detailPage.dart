import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuru/main.dart';

import 'basket.dart';

class DetailPage extends StatefulWidget {
  var aciklama;
  var imageurl;
  var kilofiyati;
  var meyvesebzeadi;
  var time;
  var user;
  DetailPage({
    Key? key,
    required this.meyvesebzeadi,
    required this.kilofiyati,
    required this.aciklama,
    required this.imageurl,
    required this.time,
    required this.user,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satın al'),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            SizedBox(height: width * 0.1),
            CachedNetworkImage(
              imageUrl: widget.imageurl,
              placeholder: (context, url) => const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            Text(widget.meyvesebzeadi),
            const SizedBox(height: 20),
            Text(widget.aciklama),
            const SizedBox(height: 20),
            Text(widget.kilofiyati),
            const Spacer(),
            Container(
              width: width,
              height: 70,
              color: Colors.black12,
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  SizedBox(
                    width: width * 0.4,
                    child: OutlinedButton(
                      onPressed: () async {
                        showCupertinoDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext ctx) {
                            return CupertinoAlertDialog(
                              content: SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: Text(
                                    'Sepete Eklendi\n${widget.kilofiyati}£',
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                        await firestore
                            .collection('basket')
                            .doc(widget.user!.uid)
                            .collection('urunler')
                            .doc()
                            .set({
                          'meyve-sebze-adi': widget.meyvesebzeadi,
                          'kilo-fiyati': widget.kilofiyati,
                          'aciklama': widget.aciklama,
                          'uploaderUID': widget.user!.uid,
                          'imageUrl': widget.imageurl,
                          'time': DateTime.now(),
                        });
                        await Future.delayed(
                            const Duration(milliseconds: 1500));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text('${widget.kilofiyati}£   Satın Al'),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const Basket()));
                    },
                    child: const Text('Sepete Git'),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
