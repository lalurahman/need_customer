import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:need_customer/invoice/invoice.dart';
import 'package:need_customer/theme/companycolors.dart';

class TransaksiSelesai extends StatefulWidget {
  TransaksiSelesai({Key key, @required this.dataLogin, @required this.dataUser, @required this.data}) : super(key: key);
  final AsyncSnapshot<FirebaseUser> dataLogin;
  final AsyncSnapshot<DocumentSnapshot> dataUser;
  final List<DocumentSnapshot> data;

  @override
  _TransaksiSelesaiState createState() => _TransaksiSelesaiState();
}

class _TransaksiSelesaiState extends State<TransaksiSelesai> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 10.0),
      // height: (widget.data.length <= 0)? 0 : 150.0,
      color: Colors.white,
      child: (widget.data.length <= 0)
          ? kosong()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Orderan Selesai',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Berikan rating untuk kurir ya..',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11.0, color: Colors.grey),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: widget.data.map((f) {
                        return wdg(f);
                      }).toList(),
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
    );
  }

  Widget kosong() {
    return Container();
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
            return Wdg(
              tglUpdated: tgl.toString(),
              clr: clr,
              f: f,
              icn: icn,
              nmDepot: snapshot.data.data['nama_depot'].toString(),
              data: widget.data,
            );
          }
        }
        return Container();
      },
    );
  }
}

class Wdg extends StatefulWidget {
  Wdg({Key key, @required this.clr, @required this.tglUpdated, @required this.f, @required this.nmDepot, @required this.icn, @required this.data}) : super(key: key);
  final DocumentSnapshot f;
  final Color clr;
  final IconData icn;
  final String nmDepot;
  final String tglUpdated;
  final List<DocumentSnapshot> data;
  @override
  _WdgState createState() => _WdgState();
}

class _WdgState extends State<Wdg> {
  double rt = 5.0;
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
        width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0, left: 3.0),
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
            (widget.f['diterima'] != null) ? (widget.f['diterima']) ? berikanRating() : diterima() : diterima(),
            // Row(
            //   children: <Widget>[
            //     Text(
            //       'Tanggal : ',
            //       style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
            //     ),
            //     Text(
            //       widget.tglUpdated.toString(),
            //       style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.orange),
            //     ),
            //     Expanded(child: Container()),
            //     Text(widget.f.documentID),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  bool loading = false;
  Widget diterima() {
    return Row(
      children: [
        Expanded(child: Container()),
        GestureDetector(
          onTap: (loading)
              ? () {}
              : () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    tittle: 'Info',
                    desc: "Orderan kamu belum diterima ya?",
                    btnCancelText: 'Tutup',
                    btnCancelOnPress: () {},
                    btnOkText: 'Belum',
                    btnOkOnPress: () async {
                      setState(() => loading = true);
                      await Firestore.instance.collection("final_transaksi").document(widget.f.documentID).updateData({"diterima": false});
                    },
                  ).show();
                },
          child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5),
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0)),
            child: Text(
              (loading) ? "Load.." : "BELUM DITERIMA",
              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        GestureDetector(
          onTap: (loading)
              ? () {}
              : () async {
                  setState(() => loading = true);
                  await Firestore.instance.collection("final_transaksi").document(widget.f.documentID).updateData({"diterima": true});
                },
          child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
            child: Text(
              (loading) ? "Load.." : "DITERIMA",
              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }

  Widget berikanRating() {
    return Row(
      children: [
        RatingBar(
          initialRating: rt,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 25.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: 14.0,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              rt = rating + .0;
            });
          },
        ),
        Expanded(child: Container()),
        GestureDetector(
          onTap: (loading)
              ? () {}
              : () async {
                  if (rt < 3.0) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      tittle: 'Info',
                      desc: "Apakah pelayanan kurir kami buruk?",
                      btnCancelText: 'Tutup',
                      btnCancelOnPress: () {},
                      btnOkText: 'IYA',
                      btnOkOnPress: () async {
                        setState(() => loading = true);
                        await Firestore.instance.collection("final_transaksi").document(widget.f.documentID).updateData({"rating": rt});
                      },
                    ).show();
                  } else {
                    setState(() => loading = true);
                    await Firestore.instance.collection("final_transaksi").document(widget.f.documentID).updateData({"rating": rt});
                  }
                },
          child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
            child: Text(
              (loading) ? "load..." : "BERI RATING",
              style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }

  String idr(int ttl) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: (ttl.toString() != null) ? double.parse(ttl.toString()) + .0 : 0.0, settings: MoneyFormatterSettings(symbol: 'IDR', thousandSeparator: '.', decimalSeparator: ',', symbolAndNumberSeparator: ' ', fractionDigits: 0, compactFormatType: CompactFormatType.short));
    return fmf.output.nonSymbol;
  }
}
