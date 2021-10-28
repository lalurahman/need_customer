import 'package:flutter/material.dart';
import 'package:need_customer/home/header/headerhome.dart';
import 'package:need_customer/home/listmenu/listmenu.dart';
import 'package:need_customer/home/berita/berita.dart';
import 'package:need_customer/home/voucher/voucher.dart';
import 'package:need_customer/notificationcustom/notificationcustom.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return NotificationCustom(
      child: Container(
        child:Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
              children: <Widget>[
                HeaderHome(),
                // MyLocation(),
                // Pemberitahuan(),
                ListMenu(),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Container(height: 8.0, color: Colors.grey[200],),
                ),
                Voucher(),
                Berita(),
              ],
            ),
        )
      ),
    );
  }
}