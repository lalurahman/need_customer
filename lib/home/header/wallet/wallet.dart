import 'package:flutter/material.dart';
import 'package:need_customer/home/header/wallet/logindone/logindone.dart';

class Wallet extends StatefulWidget {
  Wallet({Key key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool stsLogin = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Text('Selamat Datang', style: TextStyle(fontFamily: 'CinzelDecorative-Regular', color: Colors.white, fontSize: 14.0),),
            // child: Text('Selamat Sore', style: TextStyle(color: Colors.white),),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            padding: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 5)
              ]
            ),
            child: (stsLogin)?LoginDone():Row(
              children: <Widget>[
                Icon(Icons.fingerprint, size: 90.0, color: Colors.blueGrey,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Maaf,', style: TextStyle(fontWeight: FontWeight.w700),),
                    Container(
                      width: MediaQuery.of(context).size.width-200,
                      child: Text('Jika Anda Ingin Menggunakan Saldo, silahkan login terlebih dahulu', maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),)
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}