import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/theme/modalbottom.dart';

class DetailPesanan extends StatefulWidget {
  DetailPesanan({Key key, @required this.idDepot, @required this.idUser}) : super(key: key);
  final String idDepot;
  final String idUser;
  @override
  _DetailPesananState createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    loading = false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: .0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Text('Detail Pesanan', style: TextStyle(fontWeight: FontWeight.w600),),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              List<Widget>data=[];
              if (snapshot.connectionState==ConnectionState.active) {
                if (snapshot.data.documents.length>0) {
                  data = snapshot.data.documents.map((f){
                    return setDetail(f.data['value'], f.data['idkategori'], f.documentID);
                  }).toList();
                }
              }
              return Column(
                children: data,
              );
            },
          ),
        ],
      ),
    );
  }
  Widget setDetail(int jml, String idKategori, String idProduk){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('kategori').document(widget.idDepot).collection('detail_kategori').document(idKategori).collection('produk').document(idProduk).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        String namaProduk='';
        int harga = 0, total = 0;
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            namaProduk=snapshot.data.data['nama_produk'];
            harga=snapshot.data.data['harga_produk'];
            int discount = (snapshot.data.data['discount']==null)?0:snapshot.data.data['discount'];
            double discountFinal = .0;
            if (discount>0) {
              discountFinal = discount / 100 * harga;
              harga = (harga - discountFinal).round();
            }
            total=harga*jml;
          }
        }
        return detail(jml, namaProduk, harga, total, idKategori, idProduk);
      },
    );
  }
  Widget detail(int jml, String namaProduk, int harga, int total, String idKategori, String idProduk){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            // Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk')
            ModalBottom().mainBottomSheet(context, tbl(namaProduk, harga, idKategori, idProduk));
          },
          child: Container(
            color: Colors.red.withOpacity(.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 35.0,
                    height: 35.0,
                    // padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Center(
                      child: Text('x${jml.toString()}', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(namaProduk.toString(), style: TextStyle(fontWeight: FontWeight.w600),),
                        Text('Rp. ${idr(harga)}', style: TextStyle(color: Colors.grey, height: 1.5),),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Rp. ${idr(total)}', style: TextStyle(height: 1.5),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
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

  Widget tbl(String namaProduk, int harga, String idKategori, String idProduk){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(idProduk).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        int vl=0;
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            if (snapshot.data['value']!=null) {
              vl=snapshot.data['value'];
            }
          }
        }
        return tbhLantai(namaProduk, harga, idKategori, idProduk, vl);
      },
    );
  }
  Widget tbhLantai(String namaProduk, int harga, String idKategori, String idProduk, int vl){
    return Container(
      height: 110.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
            child: Text(namaProduk.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19.0),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('Rp. ${idr(harga)}', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 13),),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    if (!loading) {
                      if (!mounted) return;
                      setState(()=>loading=true);
                      if (vl>1) {
                        await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(idProduk).updateData({
                          'value':vl-1
                        });
                      }else{
                        await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').getDocuments().then((onValue2) async {
                          if (onValue2.documents.length==1) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.INFO,
                              tittle: 'Peringatan',
                              desc:   'Yakin Ingin Menghapus Keranjang?',
                              btnOkText: 'Jangan',
                              btnCancelText: 'Hapus',
                              btnCancelOnPress: () async {
                                await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).delete();
                                await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(idProduk).delete();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              btnOkOnPress: (){}
                            ).show();
                          }else{
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.INFO,
                              tittle: 'Peringatan',
                              desc:   'Yakin Ingin Menghapus Produk ini?',
                              btnOkText: 'Jangan',
                              btnCancelText: 'Hapus',
                              btnCancelOnPress: () async {
                                await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(idProduk).delete();
                                Navigator.pop(context);
                              },
                              btnOkOnPress: (){}
                            ).show();
                          }
                        });
                      }
                      setState(()=>loading=false);
                    }
                  },
                  child: Container(
                    width: 30.0, height: 30.0,
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Center(child: Text('-', style: TextStyle(color: Colors.white),)),
                  ),
                ),
                Container(
                  width: 50.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: Center(child: Text(vl.toString()),),
                ),
                GestureDetector(
                  onTap: () async {
                    if (!loading) {
                      setState(()=>loading=true);
                      await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(idProduk).updateData({
                        'value':vl+1
                      });
                      setState(()=>loading=false);
                    }
                  },
                  child: Container(
                    width: 30.0, height: 30.0,
                    decoration: BoxDecoration(color: Colors.green),
                    child: Center(child: Text('+', style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}