import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class DepotCek extends StatefulWidget {
  DepotCek({Key key, @required this.child, @required this.idDepot}) : super(key: key);
  final Widget child;
  final String idDepot;

  @override
  _DepotCekState createState() => _DepotCekState();
}

class _DepotCekState extends State<DepotCek> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_mitra').document(widget.idDepot).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            if (snapshot.data.data['aktifasi']) {
              if (snapshot.data.data['status_online']) {
                return widget.child;
              }else{
                return aktifasiOff('Depot Sedang Off');
              }
            }else{
                return aktifasiOff('Depot Belum Diaktifasi');
            }
          }
        }
        return Scaffold();
      },
    );
  }

  Widget aktifasiOff(String title){
    return Scaffold(
      backgroundColor: CompanyColors.utama,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.highlight_off, size: 70.0,),
            Padding(
              padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: Text('Maaf', style: TextStyle(fontWeight: FontWeight.w600),),
            ),
            Text(title.toString()),
          ],
        ),
      ),
    );
  }
}