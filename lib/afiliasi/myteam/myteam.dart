import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/afiliasi/myteam/detailmyteam/detailmyteam.dart';

class MyTeam extends StatefulWidget {
  MyTeam({Key key, @required this.idUser}) : super(key: key);
  final String idUser;

  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  int av = 0;
  int td = 0;
  int tl = 0;
  double aq = 0;
  String invCode = '-';
  String jenisAF = 'NS';
  int ns = 0;
  int nsD = 0;
  int ns2 = 0;
  int nsD2 = 0;

  @override
  void initState() {
    super.initState();
    av = 0;
    td = 0;
    tl = 0;
    aq = .0;
    ns = 0;
    nsD = 0;
    ns2 = 0;
    nsD2 = 0;
    invCode = '-';
    jenisAF = 'NS';
    getUserDataStrm = getUserData();
    getUserDataStrm.resume();
  }

  @override
  void dispose() { 
    if(getUserDataStrm!=null) getUserDataStrm.cancel();
    super.dispose();
  }

  StreamSubscription<DocumentSnapshot> getUserDataStrm;
  StreamSubscription<DocumentSnapshot> getUserData(){
    return Firestore.instance.collection('data_customer').document(widget.idUser).snapshots().listen((onData){
      if(!mounted) return;
      setState(() {
        invCode = '-';
        jenisAF = 'NS';
      });
      if (onData.exists) {
        if(!mounted) return;
        setState(() {
          invCode = (onData.data['ref_kode']!=null)?onData.data['ref_kode'].toString():'-';
          td = (onData.data['saldo_af']!=null)?onData.data['saldo_af']:0;
          // jenisAF = (onData.data['jenis_af']!=null)?'NS':
        });
        if (onData.data['jenis_af']!=null){
          switch (onData.data['jenis_af']) {
            case 'NS':
              if(!mounted) return;
              setState(() =>jenisAF = 'NEM');
              nsToNem(onData.data['ref_kode']);
              break;
            case 'NEM':
              if(!mounted) return;
              setState(() =>jenisAF = 'NET');
              break;
            case 'NET':
              if(!mounted) return;
              setState(() =>jenisAF = 'GOOD USER');
              break;
            default:
              if(!mounted) return;
              setState(() =>jenisAF = 'NS');
          }
        }else{
          if(!mounted) return;
          setState(() =>jenisAF = 'NS');
        }
      }
    });
  }

  nsToNem(String refKode) async {
    await Firestore.instance.collection('ketentuan').document('ket_ns_to_nem').get().then((onValue) async {
      if(!mounted) return;
      setState(() {
        nsD = 0;
        ns2 = 0;
        nsD2 = 0;
      });
      if (onValue.exists) {
        if(!mounted) return;
        setState(() {
          ns = onValue.data['ns'];
          nsD = onValue.data['ns_direct_invitation'];
        });
        await Firestore.instance.collection('data_customer').where('inv_by', isEqualTo: refKode.toString()).getDocuments().then((onValue2){
          if (onValue2.documents.length>0) {
            onValue2.documents.forEach((f) async {
              if(f.data['jenis_af']!=null) {
                if(!mounted) return;
                setState(() => nsD2=nsD2+1);
                getNs(f);
              }
            });
          }
        });
      }
    });
  }

  getNs(DocumentSnapshot f) async {
    await Firestore.instance.collection('data_customer').where('inv_by', isEqualTo: f.data['ref_kode']).getDocuments().then((onValue22){
      if (onValue22.documents.length>0) {onValue22.documents.forEach((f2) async {
        if(f2.data['jenis_af']!=null) {
          if(!mounted) return;
          setState(() => ns2=ns2+1);
          getNs(f2);
        }
      });}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 100.0,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      padding: EdgeInsets.only(bottom: 15.0, top: 15.0, left: 15.0, right: 15.0),
      decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.grey[300], blurRadius: 2.0)
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: Row(
              children: <Widget>[
                Text('My Team', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailMyteam(idUser:widget.idUser)),
                    );
                  },
                  child: Text('Detail', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.blue),)),
              ],
            ),
          ),
          Divider(color: Colors.grey,),
          Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: Row(
              children: <Widget>[
                // wdg('Recent', idr(re).toString()),
                wdg('NS (${ns.toString()})', idr(ns2).toString()),
                wdg('NSD (${nsD.toString()})', idr(nsD2).toString()),
                wdg('Total', idr(ns2+nsD2).toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  wdg(String title, String title2){
    return Expanded(child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom:6.0),
          child: Text(title2.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
        ),
        Text(title.toString(), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[700])),
      ],
    ));
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