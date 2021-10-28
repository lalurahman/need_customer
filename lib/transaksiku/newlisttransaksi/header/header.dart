import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/theme/companycolors.dart';

class Header extends StatefulWidget {
  Header({Key key, @required this.dataLogin, @required this.dataUser, @required this.data}) : super(key: key);
  final AsyncSnapshot<FirebaseUser> dataLogin;
  final AsyncSnapshot<DocumentSnapshot> dataUser;
  final List<DocumentSnapshot> data;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  int total = 0;
  int point = 0;

  @override
  void initState() {
    point = (widget.dataUser.data.data['point']!=null)?widget.dataUser.data.data['point']:0;
    getTotal();
    super.initState();
  }
  getTotal(){
    Iterable<DocumentSnapshot> hasil = widget.data.where((f)=>f['status']=='Selesai');
    setState(()=>total=0);
    hasil.forEach((f){
      setState(() {
        total=((f.data['total']!=null)?f.data['total']:0)+total;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      decoration: BoxDecoration(color: CompanyColors.utama),
      child: Stack(
        children: <Widget>[
          Container(width: MediaQuery.of(context).size.width, height: 100.0, child: Opacity(opacity: 0.5, child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,))),
          Positioned(right: 0.0, top: 0.0, child: Opacity(opacity: 0.8, child: Image.asset('assets/logo/logo2.png', width: 120.0,))),
          Container(
            width: MediaQuery.of(context).size.width, height: 100.0,
            padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 10.0),
            // decoration: BoxDecoration(color: CompanyColors.utama, gradient: LinearGradient(colors: [Colors.blue.withOpacity(0.5), CompanyColors.utama.withOpacity(0.0)])),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Total Transaksi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.0)),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Row(
                        children: <Widget>[
                          Text('Rp. ', style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w400)),
                          Text(idr(total).toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Row(
                        children: <Widget>[
                          Text('Jumlah Point ', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w400)),
                          Text(idr(point).toString(), style: TextStyle(color: Colors.orange[200], fontSize: 12.0, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String idr(int ttl){
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
      amount: (ttl.toString()!=null)?double.parse(ttl.toString())+.0:0.0, settings: MoneyFormatterSettings(
        symbol: 'IDR',
        thousandSeparator: '.',
        decimalSeparator: ',',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 0,
        compactFormatType: CompactFormatType.short
      )
    );
    return fmf.output.nonSymbol;
  }
}