import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/service/logincek.dart';
import 'package:need_customer/theme/companycolors.dart';
import 'package:need_customer/transaksiku/listtransaksiku/listtransaksiku.dart';
import 'package:need_customer/transaksiku/newlisttransaksi/newlisttransaksi.dart';
import 'package:need_customer/transaksiku/rekaptransaksiku/rekaptransaksiku.dart';

class TransaksiKu extends StatefulWidget {
  TransaksiKu({Key key}) : super(key: key);

  @override
  _TransaksiKuState createState() => _TransaksiKuState();
}

class _TransaksiKuState extends State<TransaksiKu> {
  int total = 0;
  int batalkan = 0;
  int proses = 0;
  int selesai = 0;
  int antar = 0;
  int menunggu = 0;
  List<DocumentSnapshot> data = [];
  @override
  void initState() { 
    total = 0;
    batalkan = 0;
    proses = 0;
    selesai = 0;
    antar = 0;
    menunggu = 0;
    data=[];
    getData();
    
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  getData(){
    FirebaseAuth.instance.onAuthStateChanged.listen((onDataUserLogin){
      if (onDataUserLogin!=null) {
        Firestore.instance.collection('final_transaksi').where('id_user', isEqualTo: onDataUserLogin.uid).orderBy('created_at', descending: true).limit(9999).snapshots().listen((onData){
          if (!mounted) return;
          setState(() {
            total = 0;
            batalkan = 0;
            proses = 0;
            selesai = 0;
            antar = 0;
            menunggu = 0;
            data=[];
          });
          if (onData.documents.length>0) {
            setState((){
              data=onData.documents;
            });
            onData.documents.forEach((f){
              if (this.mounted) {
                setState(()=>total++);
              }
              switch (f.data['status']) {
                case 'Menunggu Konfirmasi':
                  setState(()=>menunggu++);
                  break;
                case 'Dibatalkan':
                  setState(()=>batalkan++);
                  break;
                case 'Dalam Proses':
                  setState(()=>proses++);
                  break;
                case 'Sementara Diantar':
                  setState(()=>antar++);
                  break;
                case 'Selesai':
                  setState(()=>selesai++);
                  break;
                default:
              }
            });   
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: CompanyColors.utama,
      //   title: Text('Data Transaksi'),
      //   actions: <Widget>[
      //     // Padding(
      //     //   padding: const EdgeInsets.only(right:10.0),
      //     //   child: GestureDetector(
      //     //     onTap: () async {
      //     //       // FirebaseAuth.instance.onAuthStateChanged.listen((onDataUserLogin){
      //     //       // if (onDataUserLogin!=null) {
      //     //       //   print(onDataUserLogin.uid);
      //     //       // }});
      //     //     },
      //     //     child: Icon(Icons.insert_chart, size: 35.0,)),
      //     // )
      //   ],
      // ),
      body: LoginCek(
        lanjutSaja: false,
        fcLogin:(AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser){
          // return wdg(dataLogin, dataUser);
          return NewListTransaksi(dataLogin: dataLogin, dataUser: dataUser, data: data);
        }
      ),
    );
  }

  // Widget wdg(AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser){
  //   return Container(
  //     padding: EdgeInsets.only(top: 10.0),
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.height,
  //     color: CompanyColors.utama,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           RekapTransaksiku(idUser: dataUser.data.documentID,
  //             total:total, batalkan:batalkan, proses:proses, selesai:selesai, antar:antar, menunggu:menunggu
  //           ),
  //           ListTransaksiku(data:data),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}