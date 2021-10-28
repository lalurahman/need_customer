import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContentDepot extends StatefulWidget {
  ContentDepot({Key key, @required this.id}) : super(key: key);
  final String id;
  @override
  _ContentDepotState createState() => _ContentDepotState();
}

class _ContentDepotState extends State<ContentDepot> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_mitra').document(widget.id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        String namaDepot = '', alamatDepot = '';
        int rating = 0;
        bool buka24jam = false;
        bool outleneed = false;
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.exists) {
            namaDepot = snapshot.data.data['nama_depot'];
            alamatDepot = snapshot.data.data['alamat_depot'];
            rating = (snapshot.data.data['rating'] != null) ? snapshot.data.data['rating'] : 3;
            buka24jam = (snapshot.data.data['buka_24_jam'] != null) ? snapshot.data.data['buka_24_jam'] : false;
            outleneed = (snapshot.data.data['outlet_need'] != null) ? snapshot.data.data['outlet_need'] : false;
          }
        }
        return wdg(namaDepot, alamatDepot, rating, buka24jam, outleneed);
      },
    );
  }

  Widget wdg(String namaDepot, String alamatDepot, int rating, bool buka24jam, bool outleneed) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            namaDepot.toString(),
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              alamatDepot.toString(),
              style: TextStyle(fontSize: 13.0, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  size: 14.0,
                  color: Colors.orange,
                ),
                Text(
                  ' ${rating.toString()}.0  ',
                  style: TextStyle(fontSize: 12.0),
                ),
                Icon(
                  Icons.verified_user,
                  size: 14.0,
                  color: Colors.blue,
                ),
                Text(
                  ' Terpercaya',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                KetersediaanKurir(
                  id: widget.id,
                ),
                (!buka24jam)
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 10.0, left: 5.0),
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "Buka 24 Jam",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                (!outleneed)
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 10.0, left: 5.0),
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "OUTLET NEED AJA",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KetersediaanKurir extends StatefulWidget {
  const KetersediaanKurir({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _KetersediaanKurirState createState() => _KetersediaanKurirState();
}

class _KetersediaanKurirState extends State<KetersediaanKurir> {
  @override
  void initState() {
    super.initState();
    getDataKurirStrm = getDataKurir();
    getDataKurirStrm.resume();
  }

  @override
  void dispose() {
    super.dispose();
    if (getDataKurirStrm != null) getDataKurirStrm.cancel();
  }

  List<DocumentSnapshot> dtKurirState = [];
  StreamSubscription<QuerySnapshot> getDataKurirStrm;
  StreamSubscription<QuerySnapshot> getDataKurir() {
    return Firestore.instance.collection("data_mitra").document(widget.id.toString()).collection("kurir").snapshots().listen((dtKurir) {
      if (!mounted) return;
      setState(() => dtKurirState = []);
      if (dtKurir.documents.length > 0) {
        dtKurir.documents.forEach((e) {
          Firestore.instance.collection("data_kurir_aktifasi").document(e.documentID.toString()).snapshots().listen((dtKurirAktif) {
            if (dtKurirAktif.exists) {
              if (dtKurirAktif.data['status_aktifasi'] == true && dtKurirAktif.data['status_online'] == true) {
                if (!mounted) return;
                setState(() => dtKurirState = dtKurirState.where((element) => (element.documentID == e.documentID) ? false : true).toList());
                if (!mounted) return;
                setState(() => dtKurirState.add(e));
              } else {
                if (!mounted) return;
                setState(() => dtKurirState = dtKurirState.where((element) => (element.documentID == e.documentID) ? false : true).toList());
              }
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: (dtKurirState.length > 0)
            ? Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Jumlah Kurir ${dtKurirState.length.toString()}',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.white),
                ))
            : Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Kurir belum tersedia!!',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.white),
                )));
  }
}
