import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'package:need_customer/invoice/invoice.dart';
import 'package:need_customer/theme/companycolors.dart';

class ListData extends StatefulWidget {
  ListData({Key key, @required this.dataLogin, @required this.dataUser, @required this.data}) : super(key: key);
  final AsyncSnapshot<FirebaseUser> dataLogin;
  final AsyncSnapshot<DocumentSnapshot> dataUser;
  final List<DocumentSnapshot> data;

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 250.0,
      color: (widget.data.length <= 0) ? Colors.white : Colors.grey[200],
      child: (widget.data.length <= 0)
          ? kosong()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  children: widget.data.map((f) {
                    return wdg(f);
                  }).toList(),
                ),
              ),
            ),
    );
  }

  Widget kosong() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Data transaksi kamu masih kosong', style: TextStyle(fontWeight: FontWeight.w800)),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Order Dulu Yuk...!!',
              style: TextStyle(fontSize: 30.0, color: CompanyColors.utama, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget wdg(DocumentSnapshot f) {
    Color clr = Colors.grey;
    IconData icn = Icons.add_box;
    switch (f.data['status']) {
      case 'Menunggu Konfirmasi':
        clr = Colors.grey[800];
        icn = Icons.add_to_home_screen;
        break;
      case 'Dibatalkan':
        clr = Colors.red;
        icn = Icons.alarm_off;
        break;
      case 'Dalam Proses':
        clr = Colors.blue;
        icn = Icons.add_box;
        break;
      case 'Sementara Diantar':
        clr = Colors.green;
        icn = Icons.alarm;
        break;
      case 'Selesai':
        clr = Colors.orange;
        icn = Icons.check;
        break;
      default:
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_mitra').document(f.data['id_depot']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.exists) {
            Timestamp tglUpdatedAt = f.data['updated_at'];
            DateTime tglUpdatedAtFinal = tglUpdatedAt.toDate();
            String tgl = DateFormat.yMMMMd('en_US').format(tglUpdatedAtFinal).toString();
            return Wdg(tglUpdated: tgl.toString(), clr: clr, f: f, icn: icn, nmDepot: snapshot.data.data['nama_depot'].toString());
          }
        }
        return Container();
      },
    );
  }
}

class Wdg extends StatefulWidget {
  Wdg({Key key, @required this.clr, @required this.tglUpdated, @required this.f, @required this.nmDepot, @required this.icn}) : super(key: key);
  final DocumentSnapshot f;
  final Color clr;
  final IconData icn;
  final String nmDepot;
  final String tglUpdated;
  @override
  _WdgState createState() => _WdgState();
}

class _WdgState extends State<Wdg> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Invoice(
                    idTransaksi: widget.f.documentID,
                  )),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3.0)], borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(color: widget.clr, borderRadius: BorderRadius.circular(900.0)),
                  child: Center(
                    child: Icon(
                      widget.icn,
                      color: Colors.white,
                      size: 21.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nama Depot',
                        style: TextStyle(fontSize: 11.0, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text('${widget.nmDepot}'),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Total Order',
                        style: TextStyle(fontSize: 11.0, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Rp. ',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            Text(
                              '${idr(widget.f.data['total']).toString()}',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Text(
                  'Tanggal : ',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.tglUpdated.toString(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.orange),
                ),
                Expanded(child: Container()),
                Text(widget.f.documentID),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String idr(int ttl) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: (ttl.toString() != null) ? double.parse(ttl.toString()) + .0 : 0.0, settings: MoneyFormatterSettings(symbol: 'IDR', thousandSeparator: '.', decimalSeparator: ',', symbolAndNumberSeparator: ' ', fractionDigits: 0, compactFormatType: CompactFormatType.short));
    return fmf.output.nonSymbol;
  }
}
