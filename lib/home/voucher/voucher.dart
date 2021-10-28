import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class Voucher extends StatefulWidget {
  @override
  _VoucherState createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlipCard(
          flipOnTouch: true,
          direction: FlipDirection.VERTICAL, // default
          front: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.orange[900],
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft, end: Alignment.centerRight,
                colors: [
                  CompanyColors.utama,
                  CompanyColors.utama,
                ]
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text('KLIK, MAKA KAMU AKAN MENDAPATKAN VOUCHER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),)),
              ],
            ),
          ),
          back: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft, end: Alignment.centerRight,
                colors: [
                  CompanyColors.utama,
                  CompanyColors.utama.withOpacity(.5),
                ]
              )
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 50.0,
                  // margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: [
                        Colors.orange,
                        Colors.orange,
                      ]
                    )
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('KODE VOUCHER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 7),),
                        Text('MOMS001', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Center(child: Row(
                  children: <Widget>[
                    Text('    KLIK UNTUK GUNAKAN VOUCHER', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Colors.grey[700]),),
                  ],
                ))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}