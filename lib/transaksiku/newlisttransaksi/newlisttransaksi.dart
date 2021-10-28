import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';
import 'package:need_customer/transaksiku/newlisttransaksi/header/header.dart';
import 'package:need_customer/transaksiku/newlisttransaksi/listdata/listdata.dart';

class NewListTransaksi extends StatefulWidget {
  NewListTransaksi({Key key, @required this.data, @required this.dataLogin, @required this.dataUser}) : super(key: key);
  final AsyncSnapshot<FirebaseUser> dataLogin;
  final AsyncSnapshot<DocumentSnapshot> dataUser;
  final List<DocumentSnapshot> data;

  @override
  _NewListTransaksiState createState() => _NewListTransaksiState();
}

class _NewListTransaksiState extends State<NewListTransaksi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('List Data Transaksi', style: TextStyle(fontSize: 15.0),)),
        backgroundColor: CompanyColors.utama,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Header(dataLogin: widget.dataLogin, dataUser: widget.dataUser, data: widget.data,),
          ListData(dataLogin: widget.dataLogin, dataUser: widget.dataUser, data: widget.data,)
        ],
      ),
    );
  }
}