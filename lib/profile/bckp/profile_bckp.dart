import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:need_customer/login/login.dart';
import 'package:need_customer/service/jaringancek.dart';
import 'package:need_customer/service/logincek.dart';

class ProfileBckp extends StatefulWidget {
  ProfileBckp({Key key}) : super(key: key);

  @override
  _ProfileBckpState createState() => _ProfileBckpState();
}

class _ProfileBckpState extends State<ProfileBckp> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    return JaringanCek(
      child: LoginCek(
        lanjutSaja: false,
        fcLogin:(AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser){
          return Center(
            child: Container(
              height: (dataUser.data.data['no_hp']==null)?200:220,
              // color: Colors.red,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width-70,
                    height: (dataUser.data.data['no_hp']==null)?160:180.0,
                    margin: EdgeInsets.only(top: 40.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom:8.0, top: 30.0),
                          child: Text('Selamat Datang', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        Text(dataLogin.data.displayName.toString()),
                        (dataUser.data.data['no_hp']==null)?Container():
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(dataUser.data.data['no_hp'], style: TextStyle(fontSize: 13.0),),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    txtController..text = dataUser.data.data['no_hp'].toString();
                                  });
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.SCALE,
                                    dialogType: DialogType.INFO,
                                    dismissOnTouchOutside: false,
                                    tittle: 'Peringatan',
                                    body: tbl(),
                                    btnOkText: 'Lanjut',
                                    btnCancelText: 'Tidak',
                                    btnCancelOnPress: () {
                                      setState(() {
                                        loading=false;
                                      });
                                    },
                                    btnOkOnPress: () async {
                                      if(txtController.text.isNotEmpty){
                                        await Firestore.instance.collection('data_customer').document(dataUser.data.documentID).updateData({
                                          'no_hp':txtController.text.toString(),
                                        });
                                      }else{
                                        setState(() {
                                          loading=false;
                                        });
                                        await AwesomeDialog(
                                          context: context,
                                          animType: AnimType.SCALE,
                                          dialogType: DialogType.ERROR,
                                          dismissOnTouchOutside: false,
                                          tittle: 'Peringatan',
                                          desc:   'NO HP Tidak Boleh Kosong',
                                          btnCancelText: 'OK',
                                          btnCancelOnPress: () {},
                                        ).show();
                                      }
                                    }
                                  ).show();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  child: Text('UBAH', style: TextStyle(fontSize: 13.0, color: Colors.white),)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Text(dataLogin.data.email.toString(), style: TextStyle(color: Colors.grey, fontSize: 11.0),),
                        ),
                        Expanded(child: Container(),),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 60.0,
                                decoration: BoxDecoration(color: Colors.blue[800], borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('POINT', style: TextStyle(fontSize: 9.0, color: Colors.white),),
                                    Text(dataUser.data.data['point'].toString(), style: TextStyle(fontSize: 18.0, color: Colors.white),),
                                  ],
                                ),
                              )
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (!loading) {
                                    setState(() {
                                      loading = true;
                                    });
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.SCALE,
                                      dialogType: DialogType.INFO,
                                      tittle: 'Peringatan',
                                      desc:   'Yakin Ingin Keluar',
                                      btnOkOnPress: () async {
                                        await FirebaseMessaging().deleteInstanceID();
                                        await _auth.signOut().then((onValue) async {
                                          await _googleSignIn.signOut().then((onValue2){
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
                                      btnCancelOnPress: (){
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                    ).show();
                                  }
                                },
                                child: Container(
                                  height: 60.0,
                                  decoration: BoxDecoration(color: Colors.red[300], borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('action', style: TextStyle(fontSize: 9.0, color: Colors.white),),
                                      Text((loading)?'LOAD..':'KELUAR', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                                    ],
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ],
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 65.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(color: Colors.white, width: 3.0)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: FadeInImage(image: NetworkImage(dataUser.data.data['url_photo'].toString()), placeholder: AssetImage('assets/images/user.png'), fit: BoxFit.cover,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TextEditingController txtController;
  @override
  void initState() {
    super.initState();
    txtController=TextEditingController();
  }
  @override
  void dispose() { 
    txtController.dispose();
    super.dispose();
  }
  Widget tbl(){
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Text('Masukkan Nomor HP Yang Dapat Dihubungi, Awali Dengan (0)', textAlign: TextAlign.center, style: TextStyle(height: 1.7),),
          Text('No Anda Akan Disimpan Kedatabase', textAlign: TextAlign.center, style: TextStyle(height: 1.7, fontSize: 10.0, color: Colors.grey),),
          Text('Untuk Transaksi Selanjutnya Anda Tidak Perlu Menginput Nomor Kembali', textAlign: TextAlign.center, style: TextStyle(height: 1.7, fontSize: 10.0, color: Colors.grey),),
          TextField(
            autofocus: true,
            controller: txtController,
            keyboardType: TextInputType.number
          ),
        ],
      ),
    );
  }
}