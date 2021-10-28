import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class NewInvoice extends StatefulWidget {
  NewInvoice({Key key, @required this.idTransaksi}) : super(key: key);
  final String idTransaksi;
  @override
  _NewInvoiceState createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewInvoice> {
  String status = 'Dibatalkan';
  @override
  void initState() {
    super.initState();
    getStatusStrm = getStatus();
    getStatusStrm.resume();
  }

  @override
  void dispose() {
    getStatusStrm.cancel();
    super.dispose();
  }

  StreamSubscription<DocumentSnapshot> getStatusStrm;
  StreamSubscription<DocumentSnapshot> getStatus() {
    return Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).snapshots().listen((onData) {
      if (onData.exists) {
        if (!mounted) return;
        setState(() {
          status = onData.data['status'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Detail Tracking Order'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            padding: EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(color: (status == 'Dibatalkan')?Colors.red:CompanyColors.utama),
            child: Row(
              children: [
                (status == 'Dibatalkan')?Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.do_not_disturb, color: Colors.white, size: 35.0,)):Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ID Transaksi',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    Text(
                      widget.idTransaksi,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  (status != 'Dibatalkan') ? Container() : wdg(true, '0', false, true, 'Dibatalkan', Icons.do_not_disturb_alt, Colors.red, CompanyColors.utama, 'Orderan dibatalkan'),
                  (status == 'Dibatalkan')
                      ? Container()
                      : Column(
                          children: <Widget>[
                            wdg((status == 'Selesai' || status == 'Sementara Diantar' || status == 'Dalam Proses' || status == 'Menunggu Konfirmasi') ? true : false, '1', (status == 'Selesai' || status == 'Sementara Diantar' || status == 'Dalam Proses') ? true : false, false, 'Mencari Kurir', Icons.search, CompanyColors.utama, Colors.orange, 'Menunggu kurir untuk memproses orderan'),
                            wdg((status == 'Selesai' || status == 'Sementara Diantar' || status == 'Dalam Proses') ? true : false, '2', (status == 'Selesai' || status == 'Sementara Diantar') ? true : false, false, 'Sedang Diproses', Icons.move_to_inbox, Colors.orange, Colors.purple[600], 'Orderan kamu sementara diproses'),
                            wdg((status == 'Selesai' || status == 'Sementara Diantar') ? true : false, '3', (status == 'Selesai') ? true : false, false, 'Sedang Diantar', Icons.directions_bike, Colors.purple[600], Colors.green, 'Orderan kamu sedang diantarkan'),
                            wdg((status == 'Selesai') ? true : false, '3', false, true, 'Selesai', Icons.verified_user, Colors.green, CompanyColors.utama, 'Orderan kamu sudah selesai'),
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget wdg(bool aktif, String urutan, bool lj, bool akhir, String sts, IconData icn, Color clr, Color clr2, String subTitle) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      padding: EdgeInsets.only(left: 10.0),
      // color: Colors.teal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100.0,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 5.0,
                      height: 50.0,
                      margin: EdgeInsets.only(left: 18.0),
                      color: (aktif) ? clr : Colors.grey,
                    ),
                    (akhir)
                        ? Container()
                        : Container(
                            width: 5.0,
                            height: 50.0,
                            margin: EdgeInsets.only(left: 18.0),
                            color: (lj) ? clr2 : Colors.grey,
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(color: (aktif) ? clr : Colors.grey, borderRadius: BorderRadius.circular(999.0)),
                      child: Center(
                        child: Text(
                          urutan.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 80,
                margin: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(color: (aktif) ? clr : Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Status Tracking',
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            icn,
                            color: Colors.white,
                          ),
                          Text(
                            '  ${sts.toString()}',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      subTitle.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
