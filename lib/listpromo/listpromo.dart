import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/listpromo/datapromo/datapromo.dart';
import 'package:need_customer/listpromo/loading/loadinglist.dart';

class ListPromo extends StatefulWidget {
  ListPromo({Key key}) : super(key: key);

  @override
  _ListPromoState createState() => _ListPromoState();
}

class _ListPromoState extends State<ListPromo> {
  List<DocumentSnapshot> dataPromo=[];
  int pointAnda = 0;
  bool loading=false;
  String idUser;

  @override
  void initState() { 
    super.initState();
    getVoucherStrm = getVoucher();
    getVoucherStrm.resume();
    getUser();
  }
  @override
  void dispose() { 
    super.dispose();
    getVoucherStrm.cancel();
    if(idUser!=null)
    getDataUserStrm.cancel();
  }
  StreamSubscription<QuerySnapshot> getVoucherStrm;
  StreamSubscription<QuerySnapshot> getVoucher(){
    return Firestore.instance.collection('voucher').snapshots().listen((snapshot){
      if(!mounted) return;
      setState(()=>dataPromo=[]);
      if (snapshot.documents.length>0) {
        snapshot.documents.forEach((f){
          if (f.data['status']) {
            if(!mounted) return;
            setState(()=>dataPromo.add(f));
          }
        });
      }
      setState(()=>loading=false);
    });
  }

  StreamSubscription<DocumentSnapshot> getDataUserStrm;
  StreamSubscription<DocumentSnapshot> getDataUser(String idUser){
    return Firestore.instance.collection('data_customer').document(idUser).snapshots().listen((snapshot){
      if(!mounted) return;
      setState(()=>pointAnda=0);
      if (snapshot.exists) {
        if(!mounted) return;
        setState(()=>pointAnda=snapshot.data['point']);
      }
    });
  }

  getUser() async {
    await FirebaseAuth.instance.currentUser().then((onValue){
      if (onValue.uid!=null) {
        setState(() {
          idUser=onValue.uid;
          getDataUserStrm = getDataUser(onValue.uid);
          getDataUserStrm.resume();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return (loading)?LoadingList():(dataPromo.length>0)?DataPromo(dataPromo:dataPromo, pointAnda:pointAnda):kosong();
  }

  Widget kosong(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom:10.0),
            child: Text('Voucher', style: TextStyle(color: Colors.white),),),
          Container(child: Text('Maaf', style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w600),),),
          Container(
            padding: EdgeInsets.only(top:10.0),
            child: Text('Saat ini voucher belum ada', style: TextStyle(color: Colors.white, fontSize: 11.0),),),
        ],
      ),
    );
  }
}