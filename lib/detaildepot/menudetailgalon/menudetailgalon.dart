import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/detaildepot/menudetailgalon/cartondetail/cartondetail.dart';

class MenuDetailGalon extends StatefulWidget {
  MenuDetailGalon({Key key, @required this.id}) : super(key: key);
  final String id;
  @override
  _MenuDetailGalonState createState() => _MenuDetailGalonState();
}

class _MenuDetailGalonState extends State<MenuDetailGalon> {
  bool loadingTamabahCart=false;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('kategori').document(widget.id).collection('detail_kategori').snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        List<Widget> data=[];
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.documents.length>0) {
            data=snapshot.data.documents.map((f){
              return kategori(f.data['nama_kategori'], f.documentID);
            }).toList();
          }
        }
        return Column(
          children: data,
        );
      },
    );
  }

  Widget kategori(String kategori, String id){
    return Column(
      children: <Widget>[
        Container(
          // height: 100.0,
          padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("${kategori.toString()}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),),
              Divider(),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('kategori').document(widget.id).collection('detail_kategori').document(id).collection('produk').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  List<Widget> data=[];
                  if (snapshot.connectionState==ConnectionState.active) {
                    if (snapshot.data.documents.length>0) {
                      data=snapshot.data.documents.map((f){
                        int discount = (f.data['discount']==null)?0:f.data['discount'];
                        double discountFinal = .0;
                        int harga = f.data['harga_produk'];
                        if (discount>0) {
                          discountFinal = discount / 100 * harga;
                          discountFinal = harga - discountFinal;
                        }
                        return crd(f.data['nama_produk'], f.data['keterangan_produk'], harga, 
                          f.data['foto_produk'], (f.data['habis']!=null)?f.data['habis']:false, discountFinal,
                          f.documentID, id
                        );
                      }).toList();
                    }else{
                      return Container(
                        height: 30.0,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: Center(child: Text("Produk Kosong", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),),),
                      );
                    }
                  }
                  return Column(
                    children: data,
                  );
                },
              ),
            ],
          ),
        ),
        Container(height: 8.0, width: MediaQuery.of(context).size.width, color: Colors.grey[200],),
      ],
    );
  }

  Widget crd(String nmProduk, String ket, int harga, String urlImage, bool habis, double discount, String idProduk, String idKategori){
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 70.0, width: 70.0,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  // child: Image.network(urlImage.toString(), fit: BoxFit.cover,),
                  child: ShowImage(url:urlImage.toString()),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(nmProduk.toString(), style: TextStyle(fontWeight: FontWeight.w700),),
                    Container(
                      width: MediaQuery.of(context).size.width-140,
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Text(ket.toString(), style: TextStyle(color: Colors.grey),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Row(
                        children: <Widget>[
                          Text('Rp. ${idr(harga)}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0,
                            decoration: (discount>0)?TextDecoration.lineThrough:TextDecoration.none,),),
                          (discount>0)?
                          Text('  Rp. ${idr(discount.round())}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green, fontSize: 12.0),):
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Icon(Icons.favorite, color: Colors.grey[200],)
            ],
          ),
          CartOnDetail(idDepot: widget.id, idProduk: idProduk, habis: habis, idKategori: idKategori)
        ],
      ),
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

class ShowImage extends StatefulWidget {
  ShowImage({Key key, @required this.url}) : super(key: key);
  final String url;
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        placeholder: (context, url) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
        filterQuality: FilterQuality.low,
        imageUrl: widget.url,
        fit: BoxFit.cover,
      ),
    );
  }
}