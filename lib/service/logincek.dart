import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/login/login.dart';
import 'package:need_customer/theme/companycolors.dart';

class LoginCek extends StatefulWidget {
  LoginCek({Key key, @required this.fcLogin, this.lanjutSaja=true}) : super(key: key);
  final Function(AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser) fcLogin;
  final bool lanjutSaja;
  @override
  _LoginCekState createState() => _LoginCekState();
}

class _LoginCekState extends State<LoginCek> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.collection('data_customer').document(snapshot.data.uid).snapshots() ,
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot2){
                if (snapshot2.connectionState==ConnectionState.active) {
                  if (snapshot2.data.exists) {
                    return widget.fcLogin(snapshot, snapshot2);                  
                  }else{
                    return (widget.lanjutSaja)?aktifasiOff('User Kamu Telah DiHapus', Icons.insert_comment):widget.fcLogin(null, null);
                  }
                }
                return (!widget.lanjutSaja)?kosong():widget.fcLogin(null, null);
              },
            );
          }else{
            return (!widget.lanjutSaja)?aktifasiOff('Anda Belum Login', Icons.cancel):widget.fcLogin(null, null);
          }
        }        
        return (!widget.lanjutSaja)?Container():widget.fcLogin(null, null);
      },
    );
  }

  Widget aktifasiOff(String title, IconData icon){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: CompanyColors.utama,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 90.0, color: Colors.white,),
          Padding(
            padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
            child: Text('Maaf', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
          ),
          Text(title.toString(), style: TextStyle(color: Colors.white),),
          Padding(
            padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child: Text('Login Disini', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange),))),
          ),
        ],
      ),
    );
  }

  Widget kosong(){
    return Container(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: CompanyColors.utama,);
  }
}