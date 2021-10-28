import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:need_customer/afiliasi/afiliasi.dart';
import 'package:need_customer/login/login.dart';
import 'package:need_customer/pengaturanprofile/pengaturanprofile.dart';
import 'package:need_customer/profile/headerprofile/menuprofile/berikanrating/berikanrating.dart';
import 'package:need_customer/wishlist/wishlist.dart';

class MenuProfile extends StatefulWidget {
  MenuProfile({Key key}) : super(key: key);

  @override
  _MenuProfileState createState() => _MenuProfileState();
}

class _MenuProfileState extends State<MenuProfile> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
                // color: Colors.red
                ),
            child: Column(
              children: <Widget>[
                StreamBuilder<FirebaseUser>(
                  stream: FirebaseAuth.instance.onAuthStateChanged,
                  builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Program Afiliasi',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                )),
                            wdg('Afiliasi', () {
                              // AwesomeDialog(context: context,
                              //   dialogType: DialogType.INFO,
                              //   animType: AnimType.BOTTOMSLIDE,
                              //   tittle: 'Peringatan',
                              //   desc: 'Maaf Fitur ini belum Dapat Digunakan',
                              //   btnCancelText: 'TUTUP',
                              //   btnCancelOnPress: () {},
                              //   // btnOkOnPress: () {}
                              // ).show();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Afiliasi(idUser: snapshot.data.uid)),
                              );
                            }, true, Icons.beenhere, 'Daftarkan Program Afiliasi'),
                            Divider(),
                          ],
                        );
                      }
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          Text(
            'Pengaturan Akun',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
                // color: Colors.red
                ),
            child: Column(
              children: <Widget>[
                StreamBuilder<FirebaseUser>(
                  stream: FirebaseAuth.instance.onAuthStateChanged,
                  builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            wdg('Keluar', () {
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
                            }, true, Icons.power_settings_new, 'Keluarkan akun dari aplikasi'),
                            Divider(),
                            wdg('Pengaturan Akun', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PengaturanProfile(idUser: snapshot.data.uid)),
                              );
                            }, true, Icons.settings, 'Ubah pengaturan akun anda disini'),
                            Divider(),
                            wdg('Wishlist', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WishList(idUser: snapshot.data.uid)),
                              );
                            }, true, Icons.favorite, 'Depot yang anda sukai'),
                          ],
                        );
                      } else {
                        return wdg('Masuk', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        }, true, Icons.input, 'Hubungkan akun anda ke aplikasi');
                      }
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Pusat Bantuan',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
                // color: Colors.red
                ),
            child: Column(
              children: <Widget>[
                wdg('Hubungi Customer Service', () async {
                  await Firestore.instance.collection('ketentuan').document('whatsappCustomer').get().then((onValue) async {
                    if (onValue.exists) {
                      await FlutterOpenWhatsapp.sendSingleMessage(onValue.data['value'], "Hello");
                    }
                  });
                }, true, Icons.headset_mic, 'Anda akan diarahkan ke whatsapp CS'),
                Divider(),
                wdg('Berikan Kami Rating', () async {
                  await FirebaseAuth.instance.currentUser().then((onValue) async {
                    if (onValue != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => BerikanRating(),
                      );
                    } else {
                      AwesomeDialog(
                          context: context,
                          animType: AnimType.SCALE,
                          dialogType: DialogType.ERROR,
                          tittle: 'Maaf',
                          desc: 'Anda Belum Login',
                          btnCancelOnPress: () {},
                          btnCancelText: 'TUTUP',
                          btnOkText: 'MASUK',
                          btnOkOnPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          }).show();
                    }
                  });
                }, true, Icons.grade, 'Rating dari kualitas pelayanan kami'),
                Divider(),
                wdg('Masukan Untuk Kami', () {}, false, Icons.insert_invitation, 'Guna ngembangkan kualitas aplikasi'),
                Divider(),
                wdg('Kebijakan & Privasi', () {}, false, Icons.help_outline, 'Kebijakan dan privasi customer'),
              ],
            ),
          ),
          Container(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget wdg(String title, Function fc, bool aktif, IconData icon, String title2) {
    return GestureDetector(
      onTap: (aktif)
          ? fc
          : () {
              AwesomeDialog(context: context, animType: AnimType.SCALE, dialogType: DialogType.INFO, tittle: 'Maaf', desc: 'Fitur ini belum Dapat Digunakan', btnOkOnPress: () {}, btnOkText: 'OKE').show();
            },
      child: Container(
        color: Colors.white.withOpacity(.0),
        width: MediaQuery.of(context).size.width,
        // height: 35.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25.0,
              color: (title == 'Afiliasi') ? Colors.orange[800] : Colors.black87,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '   ${title.toString()}',
                  style: TextStyle(color: (title == 'Afiliasi') ? Colors.orange[800] : Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.5, top: 5.0),
                  child: Text(
                    '   ${title2.toString()}',
                    style: TextStyle(fontSize: 11.0, color: (title == 'Afiliasi') ? Colors.grey : Colors.grey),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.0,
              color: (title == 'Afiliasi') ? Colors.orange[800] : Colors.black87,
            )
          ],
        ),
      ),
    );
  }
}
