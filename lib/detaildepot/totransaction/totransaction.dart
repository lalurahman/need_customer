import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:need_customer/cart/cart.dart';
import 'package:need_customer/service/logincek.dart';

class ToTransaction extends StatefulWidget {
  ToTransaction({Key key, @required this.idDepot, @required this.myPosition, @required this.voucher}) : super(key: key);
  final String idDepot;
  final String voucher;
  final Position myPosition;

  @override
  _ToTransactionState createState() => _ToTransactionState();
}

class _ToTransactionState extends State<ToTransaction> {
  CollectionReference cartCr = Firestore.instance.collection('cart');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return LoginCek(
        lanjutSaja: true,
        fcLogin: (dataLogin, dataUser) {
          if (dataUser != null) {
            return tra(dataUser);
          }
          return Container();
        });
  }

  Widget tra(AsyncSnapshot<DocumentSnapshot> dataUser) {
    return StreamBuilder<QuerySnapshot>(
      stream: cartCr.document(dataUser.data.documentID).collection('detail_depot').document(widget.idDepot).collection('detail_produk').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return wdg(snapshot.data.documents.length, dataUser);
          }
        }
        return Container();
      },
    );
  }

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
    return Firestore.instance.collection("data_mitra").document(widget.idDepot.toString()).collection("kurir").snapshots().listen((dtKurir) {
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

  Widget wdg(int produk, AsyncSnapshot<DocumentSnapshot> dataUser) {
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        GestureDetector(
          onTap: () async {
            if (!loading) {
              setState(() => loading = true);
              if (dtKurirState.length > 0) {
                await Firestore.instance.collection('final_transaksi').where('id_user', isEqualTo: dataUser.data.documentID).where('id_depot', isEqualTo: widget.idDepot).where('status', isEqualTo: 'Menunggu Konfirmasi').getDocuments().then((onValue) async {
                  if (onValue.documents.length > 0) {
                    AwesomeDialog(context: context, animType: AnimType.SCALE, dialogType: DialogType.ERROR, tittle: 'Peringatan', desc: 'Maaf, Transaksi Sedang Menunggu Konfirmasi Depot', btnCancelOnPress: () {}, btnCancelText: 'OKE').show();
                  } else {
                    // print(dataUser.data.data['point']);
                    if (widget.voucher != null) {
                      await cartCr.document(dataUser.data.documentID).collection('detail_depot').document(widget.idDepot).updateData({'voucher': widget.voucher.toString()});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cart(
                                  idDepot: widget.idDepot,
                                  myPosition: widget.myPosition,
                                )),
                      );
                    } else {
                      await Firestore.instance.collection('voucher').where('point', isLessThanOrEqualTo: dataUser.data.data['point']).where('status', isEqualTo: true).orderBy('point', descending: true).getDocuments().then((onValue22) async {
                        if (onValue22.documents.length > 0) {
                          await cartCr.document(dataUser.data.documentID).collection('detail_depot').document(widget.idDepot).updateData({'voucher': onValue22.documents.first.documentID.toString()});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cart(
                                      idDepot: widget.idDepot,
                                      myPosition: widget.myPosition,
                                    )),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cart(
                                      idDepot: widget.idDepot,
                                      myPosition: widget.myPosition,
                                    )),
                          );
                        }
                      });
                    }
                  }
                });
              } else {
                AwesomeDialog(context: context, animType: AnimType.SCALE, dialogType: DialogType.ERROR, tittle: 'Peringatan', desc: 'Maaf, Kurir belum tersedia\n\nSilahkan order didepot lain', btnCancelOnPress: () {}, btnCancelText: 'OKE').show();
              }
              setState(() => loading = false);
            }
          },
          child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            decoration: BoxDecoration(color: (loading) ? Colors.grey[700] : Colors.green, borderRadius: BorderRadius.circular(5.0), boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 2.0),
            ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (loading)
                    ? Container()
                    : Icon(
                        Icons.local_grocery_store,
                        color: Colors.white,
                        size: 16.0,
                      ),
                Text(
                  (loading) ? 'Loading..' : '  Order Disini',
                  style: TextStyle(color: Colors.white),
                ),
                // (loading)?Container():Text(' (${produk.toString()} Produk Dipilih)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
              ],
            ),
          ),
        )
      ],
    );
  }
}
