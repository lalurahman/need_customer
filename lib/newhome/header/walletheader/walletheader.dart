import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/listpromo/listpromo.dart';
import 'package:need_customer/service/logincek.dart';

class WalletHeader extends StatefulWidget {
  WalletHeader({Key key}) : super(key: key);

  @override
  _WalletHeaderState createState() => _WalletHeaderState();
}

class _WalletHeaderState extends State<WalletHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.green,
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 65.0,
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
            padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black38.withOpacity(.2), blurRadius: 2.0)
              ],
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text('Dary Kusuma', style: TextStyle(fontSize: 13.0),),
                    Padding(
                      padding: const EdgeInsets.only(top:2.0, bottom: 3.0),
                      child: Text('Jumlah Point Anda', style: TextStyle(fontSize: 11.0, color: Colors.grey),),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.radio_button_checked, size: 13.0, color: Colors.pink,),
                        LoginCek(
                          lanjutSaja: true,
                          fcLogin: (AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser){
                            int jmlPoint = 0;
                            if (dataLogin!=null&&dataUser!=null) {
                              jmlPoint = dataUser.data['point'];
                            }
                            return Text(' ${jmlPoint.toString()} Point', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),);
                          }
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ListPromo()));
                    // AwesomeDialog(context: context,
                    //   dialogType: DialogType.INFO,
                    //   animType: AnimType.BOTTOMSLIDE,
                    //   tittle: 'Peringatan',
                    //   desc: 'Maaf Fitur ini belum Dapat Digunakan',
                    //   btnCancelText: 'TUTUP',
                    //   btnCancelOnPress: () {},
                    //   // btnOkOnPress: () {}
                    // ).show();
                  },
                  child: Container(
                    width: 80.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(3.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black38.withOpacity(.2), blurRadius: 1.0)
                      ]
                    ),
                    child: Center(child: Text('Voucher', style: TextStyle(color: Colors.red, fontSize: 12.0, fontWeight: FontWeight.w400),),),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}