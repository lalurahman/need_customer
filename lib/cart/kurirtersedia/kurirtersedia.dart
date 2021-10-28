import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KurirTersedia extends StatefulWidget {
  KurirTersedia({Key key, @required this.idDepot, @required this.idUser}) : super(key: key);
  final String idDepot;
  final String idUser;
  @override
  _KurirTersediaState createState() => _KurirTersediaState();
}

class _KurirTersediaState extends State<KurirTersedia> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  int jumlahkurir = 0;
  bool loadinggetKurir=true;
  getDataKurir() async {
    await Firestore.instance.collection("data_mitra").document(widget.idDepot.toString()).collection("kurir").getDocuments().then((dtKurir) {
      if (dtKurir.documents.length>0) {
        if(!mounted) return;
        setState(() {
          jumlahkurir=0;
          loadinggetKurir=true;
        });
        int no = 0;
        dtKurir.documents.forEach((element) async { 
          await Firestore.instance.collection("data_kurir").document(element.documentID.toString()).get().then((event){
            if (event.exists) {
              if (event.data['status_aktifasi']&&event.data['status_online']) {
                if(!mounted) return;
                setState(() {
                  jumlahkurir++;
                });
              }else{
                if(!mounted) return;
                setState(() {
                  jumlahkurir--;
                });
              }
            }
          });
          no++;
          if(no==dtKurir.documents.length){
            if(!mounted) return;
            setState(() {
              loadinggetKurir=false;
            });
          }
        });        
      }
    });
    return true;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return (loadinggetKurir)?Container():(jumlahkurir>0)?Container():Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(10.0)),
      child: Center(child: Text('Kurir belum tersedia!!\n\nHarap coba kembali', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.white),)));
  }
}