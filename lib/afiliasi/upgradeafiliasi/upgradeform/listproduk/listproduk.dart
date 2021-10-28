// import 'package:afiliasi/listproduk/detailproduk/detailproduk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/listproduk/detailproduk/detailproduk.dart';
import 'package:need_customer/theme/companycolors.dart';

class ListProduk extends StatefulWidget {
  ListProduk({Key key, @required this.idUser}) : super(key: key);
  final String idUser;
  @override
  _ListProdukState createState() => _ListProdukState();
}


class _ListProdukState extends State<ListProduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('List Produk'),
      ),
      body: Container(
        // height: 200.0,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('produk').snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.connectionState==ConnectionState.active) {
                if (snapshot.data.documents.length>0) {
                  return GridView.count(crossAxisCount: 2,
                    shrinkWrap: true,
                    primary: true,
                    physics: new NeverScrollableScrollPhysics(),
                    // addAutomaticKeepAlives: true,
                    padding: EdgeInsets.only(top: 0.0),
                    children: snapshot.data.documents.map((f){
                      return wdg(f.documentID.toString(), f.data['nama'].toString(), f.data['url_image'].toString(), f.data['harga']);
                    }).toList(),
                    // children: [
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/medium//100/MTA-4981537/onlinebaby-id_baju_bayi_jumpsuit_import_lucu_termurah_y0047_full04_jvp8f3wr.jpg?output-format=webp', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    //   wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
                    // ],
                  );
                }
              }
              return Container();
            },
          ),
          // child: GridView.count(crossAxisCount: 2,
          //   shrinkWrap: true,
          //   primary: true,
          //   physics: new NeverScrollableScrollPhysics(),
          //   // addAutomaticKeepAlives: true,
          //   padding: EdgeInsets.only(top: 0.0),
          //   children: [
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/medium//100/MTA-4981537/onlinebaby-id_baju_bayi_jumpsuit_import_lucu_termurah_y0047_full04_jvp8f3wr.jpg?output-format=webp', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //     wdg('id1', 'Produk 1', 'https://s.blanja.com/picspace/359/100711/2048.2048_af67aa5e84424e11b70ba3751a0f99f5.jpg', 100000),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget wdg(String idProduk, String title, String urlImage, int harga){
    return GestureDetector(
      onTap: () async {
        DocumentSnapshot dataProdukState = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailProduk(idProduk: idProduk,)));
        if (dataProdukState!=null) {
          print(dataProdukState);
          Navigator.pop(context, dataProdukState);
        }
      },
      child: Container(
        // width: 50.0, height: 50.0,
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(urlImage, fit: BoxFit.cover,)),
            ),
            Column(
              children: <Widget>[
                Expanded(child: Container()),
                Container(
                  padding: const EdgeInsets.only(bottom:0.0),
                  width: MediaQuery.of(context).size.width,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: CompanyColors.utama.withOpacity(1.0),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(title.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(top:1.0),
                        child: Text('Rp. ${idr(harga).toString()}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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