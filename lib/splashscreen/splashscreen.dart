import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:need_customer/homebegin/homebegin.dart';
import 'package:need_customer/theme/companycolors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startSplahScreen() {
    var duration = const Duration(seconds: 5);
    imageCache.clear();
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();
    return Timer(duration, () async {
      await showDialog(
          context: context,
          builder: (_) => Container(
                child: Center(
                  child: Container(
                    width: 290.0,
                    height: 240.0,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(child: Container()),
                            Material(
                              type: MaterialType.transparency,
                              child: Container(
                                width: 290,
                                height: 210,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 100.0, top: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Selamat Datang Di',
                                            style: TextStyle(color: Colors.grey[700], fontSize: 12.0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'need',
                                                  style: TextStyle(color: Colors.cyan[300], fontWeight: FontWeight.w700, fontSize: 17.0),
                                                ),
                                                Text(
                                                  'Aja!',
                                                  style: TextStyle(color: Colors.cyan[300], fontWeight: FontWeight.w700, fontSize: 17.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: Text(
                                        'Pertama kali hadir di indonesia. Aplikasi Depot online, untuk pemesanan air galon. Sekarang kamu gak bakal ribet lagi.... 😎⁣',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(height: 1.5),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 290,
                                        height: 45.0,
                                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))),
                                        child: Center(
                                            child: Text(
                                          'OKE, Mengerti..',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Image.asset(
                            'assets/logo/logo3.png',
                            width: 80.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return HomeBegin();
        // return NewHome();
      }));
    });
  }

  @override
  void initState() {
    super.initState();
    startSplahScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Opacity(
              opacity: 1.0,
              child: Image.asset(
                'assets/images/pattern.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              CompanyColors.utama.withOpacity(.2),
              Colors.blue.withOpacity(.2),
            ])),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.blue[900].withOpacity(.8),
                CompanyColors.utama.withOpacity(.8),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo/logo4.png',
                    width: 150.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/images/city.png',
                      width: MediaQuery.of(context).size.width,
                    )),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  'Selamat Datang Di',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'need',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                      Text(
                        'Aja!',
                        style: TextStyle(color: Colors.blue[200], fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
