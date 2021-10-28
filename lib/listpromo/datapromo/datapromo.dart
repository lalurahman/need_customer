import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/detailvoucher/detailvoucher.dart';
import 'package:need_customer/theme/companycolors.dart';

class DataPromo extends StatefulWidget {
  DataPromo({Key key, @required this.dataPromo, @required this.pointAnda}) : super(key: key);
  final List<DocumentSnapshot> dataPromo;
  final int pointAnda;
  @override
  _DataPromoState createState() => _DataPromoState();
}

class _DataPromoState extends State<DataPromo> {
  String voucher;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // print('voucher : ${voucher.toString()}');
        Navigator.pop(context, voucher);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Voucher Yang Tersedia'),
          backgroundColor: CompanyColors.utama,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: CompanyColors.utama.withOpacity(0.9),
            ),
            Padding(
              padding: const EdgeInsets.only(top:65.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: widget.dataPromo.map((f){
                        return wdg(f.data['point'], f.data['jenis'], f.data['url_photo'], f.documentID);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(color: CompanyColors.utama.withOpacity(.6), 
                boxShadow: [
                  // BoxShadow(color: Colors.black38, blurRadius: 2.0)
                ]
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.local_play, color: Colors.white, size: 28.0,),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Jumlah point anda', style: TextStyle(color: Colors.white, fontSize: 11.0),),
                        Text('${widget.pointAnda.toString()} Point', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wdg(int point, String jenis, String urlPhoto, String id){
    return GestureDetector(
      onTap: () async {
        String voucher2 = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailVoucher(idPromo: id.toString(),)),
        );
        // print('voucher ... : ${voucher2.toString()}');
        if (voucher2!=null){
          setState(() {
            voucher = voucher2.toString();
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width-210,
        margin: EdgeInsets.only(left: 10.0, bottom: 10.0, top: 5.0, right: 10.0),
        decoration: BoxDecoration(
          color: CompanyColors.utama,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 2.0)
          ]
        ),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(bottom: 40.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                child: ShowImage(url: urlPhoto.toString(),)),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(child: Container(),),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(point.toString(), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0),),
                        Text(' Point', style: TextStyle(fontSize: 12.0),),
                        Expanded(child: Container()),
                        Container(width: 100.0, height: 25.0, decoration: BoxDecoration(color: Colors.orange[400], borderRadius: BorderRadius.circular(5.0)),
                          child: Center(child: Text('Tukarkan', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w600),)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(right: 10.0, top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Container()),
                  Container(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(.9), borderRadius: BorderRadius.circular(3.0)),
                    child: Text((jenis.toString()=='gratis ongkir')?'Gratis Ongkir':(jenis.toString()=='potongan subtotal')?'Potongan Subtotal':jenis.toString(), style: TextStyle(fontSize: 12.0),),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          child: Center(child: CircularProgressIndicator()),
        ),
        filterQuality: FilterQuality.low,
        imageUrl: widget.url,
        fit: BoxFit.cover,
      ),
    );
  }
}