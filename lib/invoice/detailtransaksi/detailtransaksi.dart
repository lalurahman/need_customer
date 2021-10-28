import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/invoice/detailtransaksi/batalkantransaksi/batalkantransaksi.dart';
import 'package:need_customer/newinvoice/newinvoice.dart';
import 'package:need_customer/theme/companycolors.dart';

class DetailTransaksi extends StatefulWidget {
  DetailTransaksi({Key key, @required this.idTransaksi, @required this.dataSn, @required this.batalkan}) : super(key: key);
  final String idTransaksi;
  final DocumentSnapshot dataSn;
  final bool batalkan;
  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Id Transaksi',
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      Text(
                        widget.idTransaksi,
                        style: TextStyle(fontWeight: FontWeight.w600, height: 1.7, color: CompanyColors.utama),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Nama Depot',
                          style: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance.collection('data_mitra').document(widget.dataSn['id_depot']).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          String namaDepot = '';
                          if (snapshot.connectionState == ConnectionState.active) {
                            if (snapshot.data.exists) {
                              namaDepot = snapshot.data.data['nama_depot'];
                            }
                          }
                          return Text(
                            namaDepot.toString(),
                            style: TextStyle(fontWeight: FontWeight.w600, height: 1.7, color: CompanyColors.utama),
                          );
                        },
                      ),
                      (widget.dataSn['id_kurir'] == null)
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Nama Kurir',
                                style: TextStyle(color: Colors.grey, fontSize: 10.0),
                              ),
                            ),
                      (widget.dataSn['id_kurir'] == null)
                          ? Container()
                          : StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance.collection('data_kurir').document(widget.dataSn['id_kurir']).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                String namaKurir = '';
                                if (snapshot.connectionState == ConnectionState.active) {
                                  if (snapshot.data.exists) {
                                    namaKurir = snapshot.data.data['nama'];
                                  }
                                }
                                return Text(
                                  namaKurir.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w600, height: 1.7, color: CompanyColors.utama),
                                );
                              },
                            ),
                    ],
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewInvoice(
                                    idTransaksi: widget.idTransaksi,
                                  )),
                        );
                      },
                      child: Icon(
                        Icons.av_timer,
                        size: 30.0,
                        color: CompanyColors.utama,
                      ))
                ],
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            detailItem(),
            fiturYangAktif(),
            totalTransaksi(),
            (!widget.batalkan)
                ? Container()
                : BtalkanTransaksi(
                    dataSn: widget.dataSn,
                    idTransaksi: widget.idTransaksi,
                  ),
          ],
        ),
      ),
    );
  }

  Widget fiturYangAktif() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
          child: Text(
            "Fitur yang digunakan",
            style: TextStyle(color: Colors.grey, fontSize: 10.0),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              ak('Express', widget.dataSn['express']),
              ak('Voucher', widget.dataSn['status_voucher']),
              ak('Jemput Antar', widget.dataSn['status_jemput_antar']),
              ak('Lantai Atas', widget.dataSn['status_lantai']),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget ak(String title, bool aktif) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(color: (aktif) ? Colors.orange : Colors.grey[700], borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        title.toString(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget detailItem() {
    List dataSn2 = widget.dataSn['list_produk'];
    return (dataSn2.length == 0)
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dataSn2.map((f) {
                    return wdgItem(f['nama_produk'], f['harga_discount'], f['total'], f['value']);
                  }).toList(),
                ),
              ],
            ),
          );
  }

  Widget totalTransaksi() {
    List dataSn2 = widget.dataSn['list_produk'];
    return (dataSn2.length == 0)
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance.collection('ketentuan').document('ongkir').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    int lantai = widget.dataSn['lantai'];
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data.exists) {
                        lantai = lantai * snapshot.data.data['per_lantai'];
                      }
                    }
                    return Column(
                      children: <Widget>[
                        wdgItem2('Biaya Lantai', lantai),
                      ],
                    );
                  },
                ),
                wdgItem2('Chrage Per Item', (widget.dataSn['chrage_per_item'] == null) ? 0 : widget.dataSn['chrage_per_item']),
                wdgItem2('Jemput Antar', widget.dataSn['jemput_antar']),
                wdgItem2('Harga', widget.dataSn['sub_total']),
                wdgItem2('Ongkir', widget.dataSn['ongkir']),
                wdgItem2('Total', widget.dataSn['total']),
              ],
            ),
          );
  }

  Widget wdgItem2(String title, int harga) {
    return Container(
      // margin: EdgeInsets.only(bottom: 5.0, right 15.0),
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Container()),
          Text(
            '${title.toString()} : ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Container(
            width: 100.0,
            child: Text(
              'Rp.${idr(harga)}',
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  Widget wdgItem(String nmProduk, int hargaProduk, int total, int value) {
    return Container(
      // margin: EdgeInsets.only(bottom: 5.0, right 15.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 33.0,
                height: 33.0,
                margin: EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey[300])),
                child: Center(
                    child: Text(
                  'x${value.toString()}',
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nmProduk.toString(),
                    style: TextStyle(),
                  ),
                  Text(
                    'Rp.${idr(hargaProduk)}',
                    style: TextStyle(height: 1.6, color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Text(
                'Rp.${idr(total)}',
                style: TextStyle(height: 1.6),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  String idr(int ttl) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: (ttl.toString() != null) ? double.parse(ttl.toString()) + .0 : 0.0, settings: MoneyFormatterSettings(symbol: 'IDR', thousandSeparator: '.', decimalSeparator: ',', symbolAndNumberSeparator: ' ', fractionDigits: 0, compactFormatType: CompactFormatType.short));
    return fmf.output.nonSymbol;
  }
}
