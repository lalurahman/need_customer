import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:need_customer/invoice/invoice.dart';

class LanjutTransaksi extends StatefulWidget {
  LanjutTransaksi({Key key, @required this.idDepot, @required this.idUser, @required this.subTotalInt, @required this.subTotalOldInt, @required this.finTotalInt, @required this.ongkirInt, @required this.ongkirOldInt, @required this.potonganSubTotalInt, @required this.minOngkir, @required this.maxOngkir, @required this.lantaiTotInt, @required this.lantaiInt, @required this.perLantaiInt, @required this.jemputAntarInt, @required this.gratisOngir, @required this.voucherEnable, @required this.express, @required this.jemputAntar, @required this.kodeVoucher, @required this.jmlItem, @required this.jarakInt, @required this.latlong, @required this.alamat, @required this.chrgPerITem, @required this.listProduk, @required this.dataUser, @required this.pointKuInt, @required this.potonganPointKuInt}) : super(key: key);
  final String idDepot, idUser;
  final int subTotalInt, subTotalOldInt, finTotalInt, ongkirInt, chrgPerITem;
  final int ongkirOldInt, potonganSubTotalInt, minOngkir, maxOngkir;
  final int lantaiTotInt, lantaiInt, perLantaiInt, jemputAntarInt, jmlItem, jarakInt, pointKuInt, potonganPointKuInt;
  final bool gratisOngir, voucherEnable, express, jemputAntar;
  final String kodeVoucher, alamat;
  final GeoPoint latlong;
  final List<Map<String, dynamic>> listProduk;
  final AsyncSnapshot<DocumentSnapshot> dataUser;

  @override
  _LanjutTransaksiState createState() => _LanjutTransaksiState();
}

class _LanjutTransaksiState extends State<LanjutTransaksi> {
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    if (getDataKurirStrm != null) getDataKurirStrm.cancel();
    txtController.dispose();
  }

  @override
  void initState() {
    super.initState();
    txtController = TextEditingController();
    getDataKurirStrm = getDataKurir();
    getDataKurirStrm.resume();
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

  @override
  Widget build(BuildContext context) {
    return (widget.alamat == null)
        ? Container()
        : GestureDetector(
            onTap: () async {
              if (!loading) {
                if (!mounted) return;
                setState(() {
                  loading = true;
                });
                if (dtKurirState.length > 0) {
                  if (widget.dataUser.data.data['no_hp'] != null) {
                    Map<String, dynamic> data = {'jumlah_item': widget.jmlItem, 'total': widget.finTotalInt, 'chrage_per_item': widget.chrgPerITem, 'ongkir': widget.ongkirInt, 'ongkir_lama': widget.ongkirOldInt, 'gratis_ongkir': widget.gratisOngir, 'sub_total': widget.subTotalInt, 'sub_total_lama': widget.subTotalOldInt, 'potongan_sub_total': widget.potonganSubTotalInt, 'jemput_antar': widget.jemputAntarInt, 'status_jemput_antar': widget.jemputAntar, 'lantai': widget.lantaiInt, 'status_lantai': (widget.lantaiInt > 0) ? true : false, 'status_voucher': widget.voucherEnable, 'created_at': DateTime.now(), 'updated_at': DateTime.now(), 'express': widget.express, 'jarak': widget.jarakInt, 'voucher': (widget.kodeVoucher == null) ? '-' : widget.kodeVoucher, 'latlong': widget.latlong, 'alamat': widget.alamat, 'list_produk': widget.listProduk, 'id_depot': widget.idDepot, 'id_user': widget.idUser, 'status': 'Menunggu Konfirmasi', 'point_ku': widget.pointKuInt, 'potongan_point_ku': widget.potonganPointKuInt};
                    await AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.INFO,
                        dismissOnTouchOutside: false,
                        tittle: 'Peringatan',
                        desc: 'Yakin Ingin Melanjutkan Transaksi?',
                        btnOkText: 'Lanjut',
                        btnCancelText: 'Tidak',
                        btnCancelOnPress: () {
                          setState(() {
                            loading = false;
                          });
                        },
                        btnOkOnPress: () async {
                          Random random = new Random();
                          String rdm = 'TRS-${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}-${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}-${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}';
                          await Firestore.instance.collection('final_transaksi').document(rdm).setData(data).then((onValue) async {
                            if (widget.voucherEnable) {
                              await Firestore.instance.collection('data_customer').document(widget.idUser).updateData({'point': widget.potonganPointKuInt});
                              await Firestore.instance.collection('voucher').document(widget.kodeVoucher).get().then((onValue22) async {
                                if (onValue22.exists) {
                                  await Firestore.instance.collection('voucher').document(widget.kodeVoucher).updateData({'stok': onValue22.data['stok'] - 1});
                                }
                              });
                            }
                            widget.listProduk.forEach((f) async {
                              await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(f['id_produk']).delete();
                            });
                            await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).delete();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Invoice(
                                          idTransaksi: rdm,
                                        )));
                          });
                        }).show();
                  } else {
                    AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.INFO,
                        dismissOnTouchOutside: false,
                        tittle: 'Peringatan',
                        body: tbl(),
                        btnOkText: 'Lanjut',
                        btnCancelText: 'Tidak',
                        btnCancelOnPress: () {
                          setState(() {
                            loading = false;
                          });
                        },
                        btnOkOnPress: () async {
                          if (txtController.text.isNotEmpty) {
                            Map<String, dynamic> data = {'jumlah_item': widget.jmlItem, 'total': widget.finTotalInt, 'ongkir': widget.ongkirInt, 'ongkir_lama': widget.ongkirOldInt, 'gratis_ongkir': widget.gratisOngir, 'sub_total': widget.subTotalInt, 'sub_total_lama': widget.subTotalOldInt, 'potongan_sub_total': widget.potonganSubTotalInt, 'jemput_antar': widget.jemputAntarInt, 'status_jemput_antar': widget.jemputAntar, 'lantai': widget.lantaiInt, 'status_lantai': (widget.lantaiInt > 0) ? true : false, 'status_voucher': widget.voucherEnable, 'created_at': DateTime.now(), 'updated_at': DateTime.now(), 'express': widget.express, 'jarak': widget.jarakInt, 'voucher': (widget.kodeVoucher == null) ? '-' : widget.kodeVoucher, 'latlong': widget.latlong, 'alamat': widget.alamat, 'list_produk': widget.listProduk, 'id_depot': widget.idDepot, 'id_user': widget.idUser, 'status': 'Menunggu Konfirmasi', 'point_ku': widget.pointKuInt, 'potongan_point_ku': widget.potonganPointKuInt};
                            Random random = new Random();
                            String rdm = 'TRS-${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}-${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}-${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}';
                            await Firestore.instance.collection('final_transaksi').document(rdm).setData(data).then((onValue) async {
                              if (widget.voucherEnable) {
                                await Firestore.instance.collection('data_customer').document(widget.idUser).updateData({'point': widget.potonganPointKuInt, 'no_hp': txtController.text.toString()});
                                await Firestore.instance.collection('voucher').document(widget.kodeVoucher).get().then((onValue22) async {
                                  if (onValue22.exists) {
                                    await Firestore.instance.collection('voucher').document(widget.kodeVoucher).updateData({'stok': onValue22.data['stok'] - 1});
                                  }
                                });
                              } else {
                                await Firestore.instance.collection('data_customer').document(widget.idUser).updateData({
                                  'no_hp': txtController.text.toString(),
                                });
                              }
                              widget.listProduk.forEach((f) async {
                                await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(f['id_produk']).delete();
                              });
                              await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).delete();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Invoice(
                                            idTransaksi: rdm,
                                          )));
                              setState(() {
                                loading = false;
                              });
                            });
                          } else {
                            setState(() {
                              loading = false;
                            });
                            await AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.ERROR,
                              dismissOnTouchOutside: false,
                              tittle: 'Peringatan',
                              desc: 'NO HP Tidak Boleh Kosong',
                              btnCancelText: 'OK',
                              btnCancelOnPress: () {},
                            ).show();
                          }
                        }).show();
                  }
                } else {
                  peringatan("Maaf, Kurir belum tersedia\n\nHarap coba kembali");
                }
                setState(() {
                  loading = false;
                });
              }
            },
            child: Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(color: (loading) ? Colors.grey[800] : Colors.blue, borderRadius: BorderRadius.circular(10.0), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (loading) ? 'loading..' : 'Lanjut Ketransaksi',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
  }

  TextEditingController txtController;
  Widget tbl() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Text(
            'Masukkan Nomor HP Yang Dapat Dihubungi, Awali Dengan (0)',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.7),
          ),
          Text(
            'No Anda Akan Disimpan Kedatabase',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.7, fontSize: 10.0, color: Colors.grey),
          ),
          Text(
            'Untuk Transaksi Selanjutnya Anda Tidak Perlu Menginput Nomor Kembali',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.7, fontSize: 10.0, color: Colors.grey),
          ),
          TextField(autofocus: true, controller: txtController, keyboardType: TextInputType.number, inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ]),
        ],
      ),
    );
  }

  peringatan(String title) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      tittle: 'Peringatan',
      desc: title,
      btnCancelText: 'OKE',
      btnCancelOnPress: () {},
    ).show();
  }
}
