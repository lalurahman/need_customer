import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:need_customer/listdepot/listdepot.dart';
import 'package:need_customer/listpromo/datapromo/datapromo.dart';
import 'package:need_customer/listpromo/listpromo.dart';
import 'package:need_customer/login/login.dart';
import 'package:need_customer/theme/companycolors.dart';

class ContentHeader extends StatefulWidget {
  ContentHeader({Key key}) : super(key: key);

  @override
  _ContentHeaderState createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  int _current = 0;
  bool loading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [
      dt('Selamat Datang', 'Temukan depot terdekat dari anda', 'Lihat depot disini', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListDepot(
                    brOnly: false,
                    alOnly: false,
                    roOnly: false,
                    ufOnly: false,
                    aquaOnly: false,
                    clubOnly: false,
                    cleoOnly: false,
                    vitOnly: false,
                  )),
        );
      }, 'Lihat Depot', Icons.assignment),
      StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return dt('Selamat Datang', 'Keluar dari akun?', null, () {
                  if (!loading) {
                    setState(() {
                      loading = true;
                    });
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.INFO,
                      tittle: 'Peringatan',
                      desc: 'Yakin Ingin Keluar',
                      btnOkOnPress: () async {
                        await FirebaseMessaging().deleteInstanceID();
                        await _auth.signOut().then((onValue) async {
                          await _googleSignIn.signOut().then((onValue2) {
                            setState(() {
                              loading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          });
                        });
                      },
                      btnCancelOnPress: () {
                        setState(() {
                          loading = false;
                        });
                      },
                    ).show();
                  }
                }, 'Keluar Disini', Icons.power_settings_new);
              } else {
                return dt('Selamat Datang', 'Silahkan login disni', null, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }, 'Login Disini', Icons.person);
              }
            }

            return Container();
          }),
      dt('Promo', 'Promo menarik untuk kamu', 'Lihat promo disini', () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListPromo()));
      }, 'Lihat Promo', Icons.priority_high),
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 220.0,
      padding: EdgeInsets.only(bottom: 10.0),
      // decoration: BoxDecoration(color: CompanyColors.utama),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              items: itemList,
              options: CarouselOptions(
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  aspectRatio: 2.3,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: itemList.map((url) {
                int index = itemList.indexOf(url);
                return Container(
                  width: 10.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: _current == index ? Colors.white : Colors.white.withOpacity(.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget dt(String title, String subtitle, String subsub, Function fc, String tBtn, IconData icon) {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 20.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toString(),
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              subtitle.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
          (subsub == null)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Text(
                    subsub.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
          GestureDetector(
            onTap: fc,
            child: Container(
              width: 140.0,
              height: 35.0,
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.white), boxShadow: [BoxShadow(color: Colors.black38.withOpacity(.2), blurRadius: 2.0)]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: CompanyColors.utama,
                    size: 15.0,
                  ),
                  Text(
                    ' ${tBtn.toString()}',
                    style: TextStyle(color: CompanyColors.utama, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
