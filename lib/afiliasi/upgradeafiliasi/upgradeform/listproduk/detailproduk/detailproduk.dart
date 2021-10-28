import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/theme/companycolors.dart';

class DetailProduk extends StatefulWidget {
  DetailProduk({Key key, @required this.idProduk}) : super(key: key);
  final String idProduk;
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Detail Pruduk'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('produk').document(widget.idProduk.toString()) .snapshots() ,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          String nama = '-';
          String subNama = '-';
          String deskripsi = '-';
          String urlPhoto;
          List fotolain=[];
          int harga = 0;
          if (snapshot.connectionState==ConnectionState.active) {
            if (snapshot.data.exists) {
              nama = snapshot.data.data['nama'];
              subNama = snapshot.data.data['sub_nama'];
              harga = snapshot.data.data['harga'];
              deskripsi = snapshot.data.data['deskripsi'];
              urlPhoto = snapshot.data.data['url_image'];
              if(snapshot.data.data['fotolain']!=null){
                fotolain = snapshot.data.data['fotolain'];
              }
            }
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: CompanyColors.utama,
                      ),
                      child: (urlPhoto==null)?Container():Image.network(urlPhoto.toString(), fit: BoxFit.cover,),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.black.withOpacity(.5),
                          Colors.white.withOpacity(.0),
                        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      padding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(nama.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),),
                          ),
                          // Text(subNama.toString(), style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: fotolain.map((f){
                        return wdgImage(f.toString());
                      }).toList(),
                    )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Harga Produk', style: TextStyle(fontSize: 13.0),),
                      Padding(
                        padding: EdgeInsets.only(top:5.0, bottom: .0),
                        child: Text('Rp. ${idr(harga).toString()}', style: TextStyle(fontSize: 20.0),),
                      ),
                      Divider(),
                      Text('Detail Produk', style: TextStyle(fontSize: 13.0),),
                      Padding(
                        padding: EdgeInsets.only(top:5.0, bottom: 5.0),
                        child: Text(deskripsi.toString(), style: TextStyle(fontSize: 13.0,), textAlign: TextAlign.justify,),
                      ),
                    ],
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context, snapshot.data);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    height: 40.0,
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text('PILIH PRODUK INI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget wdgImage(String urlImage){
    return Container(
      width: 120.0,
      height: 100,
      margin: EdgeInsets.only(right: 1.0),
      decoration: BoxDecoration(
        color: Colors.grey[200]
      ),
      child: Image.network(urlImage.toString(), fit: BoxFit.cover,),
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
}