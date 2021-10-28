import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/service/logincek.dart';

class LoginDone extends StatefulWidget {
  LoginDone({Key key}) : super(key: key);

  @override
  _LoginDoneState createState() => _LoginDoneState();
}

class _LoginDoneState extends State<LoginDone> {
  @override
  Widget build(BuildContext context) {
    return LoginCek(
      lanjutSaja: true,
      fcLogin: (AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser){
        int jmlPoint = 0;
        if (dataLogin!=null&&dataUser!=null) {
          jmlPoint = dataUser.data['point'];
        }
        return wdg(jmlPoint);
      }
    );
  }

  Widget wdg(int jmlPoint){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Jumlah Point', style: TextStyle(fontWeight: FontWeight.w700),),
            Expanded(child: Container()),
            Text(jmlPoint.toString(), style: TextStyle(fontWeight: FontWeight.w700),),
            Text(' Point', style: TextStyle(fontWeight: FontWeight.w300),),
          ],
        ),
        // Divider(height: 20,),
        // Row(
        //   children: <Widget>[
        //     card('Isi Saldo', Icons.file_download, (){
        //       AwesomeDialog(context: context,
        //         dialogType: DialogType.INFO,
        //         animType: AnimType.BOTTOMSLIDE,
        //         tittle: 'Peringatan',
        //         desc: 'Maaf Fitur ini belum Dapat Digunakan',
        //         btnCancelText: 'TUTUP',
        //         btnCancelOnPress: () {},
        //         // btnOkOnPress: () {}
        //       ).show();
        //     }),
        //     card('Penarikan', Icons.file_upload, (){
        //       AwesomeDialog(context: context,
        //         dialogType: DialogType.INFO,
        //         animType: AnimType.BOTTOMSLIDE,
        //         tittle: 'Peringatan',
        //         desc: 'Maaf Fitur ini belum Dapat Digunakan',
        //         btnCancelText: 'TUTUP',
        //         btnCancelOnPress: () {},
        //         // btnOkOnPress: () {}
        //       ).show();
        //     }),
        //     card('Promo', Icons.receipt, (){
        //       AwesomeDialog(context: context,
        //         dialogType: DialogType.INFO,
        //         animType: AnimType.BOTTOMSLIDE,
        //         tittle: 'Peringatan',
        //         desc: 'Maaf Fitur ini belum Dapat Digunakan',
        //         btnCancelText: 'TUTUP',
        //         btnCancelOnPress: () {},
        //         // btnOkOnPress: () {}
        //       ).show();
        //     }),
        //     card('Bantuan', Icons.info, (){
        //       AwesomeDialog(context: context,
        //         dialogType: DialogType.INFO,
        //         animType: AnimType.BOTTOMSLIDE,
        //         tittle: 'Peringatan',
        //         desc: 'Maaf Fitur ini belum Dapat Digunakan',
        //         btnCancelText: 'TUTUP',
        //         btnCancelOnPress: () {},
        //         // btnOkOnPress: () {}
        //       ).show();
        //     }),
        //   ],
        // ),
      ],
    );
  }

  Widget card(String title, IconData icon, Function onTap){
    return Expanded(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(bottom: 5.0),
              height: 40.0,
              child: Center(
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  // decoration: BoxDecoration(color: Color(0xff73d7d7)),
                  child: Icon(icon, size: 40.0, color: Colors.black.withOpacity(.7),),
                ),
              ),
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12.0),)
        ],
      )
    );
  }
}