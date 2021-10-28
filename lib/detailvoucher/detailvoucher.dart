import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/theme/companycolors.dart';

class DetailVoucher extends StatefulWidget {
  DetailVoucher({Key key, @required this.idPromo}) : super(key: key);
  final String idPromo;

  @override
  _DetailVoucherState createState() => _DetailVoucherState();
}

class _DetailVoucherState extends State<DetailVoucher> {
  final key = new GlobalKey<ScaffoldState>();
  String voucher;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // print('voucher ....... : ${voucher.toString()}');
        Navigator.pop(context, voucher);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Promo'),
          backgroundColor: CompanyColors.utama,
        ),
        key: key,
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('voucher').document(widget.idPromo).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              String urlImage,ket='', jenis='';
              bool stsPakai = true;
              int point=0, voucherStok=0, min=0, max=0;
              DateTime tglExp = DateTime.now();
              if (snapshot.connectionState==ConnectionState.active) {
                if (snapshot.data.exists) {
                  urlImage=snapshot.data.data['url_photo'];
                  ket=snapshot.data.data['keterangan'];
                  point=snapshot.data.data['point'];
                  voucherStok=snapshot.data.data['stok'];
                  stsPakai=snapshot.data.data['sekali_pakai'];
                  jenis=(snapshot.data.data['jenis'].toString()=='gratis ongkir')?'Gratis Ongkir':(snapshot.data.data['jenis'].toString()=='potongan subtotal')?'Potongan Subtotal':snapshot.data.data['jenis'].toString();
                  min=(snapshot.data.data['jenis'].toString()=='gratis ongkir')?snapshot.data.data['min_ongkir']:(snapshot.data.data['jenis'].toString()=='potongan subtotal')?snapshot.data.data['min_subtotal']:0;
                  max=(snapshot.data.data['jenis'].toString()=='gratis ongkir')?snapshot.data.data['max_ongkir']:(snapshot.data.data['jenis'].toString()=='potongan subtotal')?snapshot.data.data['max_subtotal']:0;
                  Timestamp exp = snapshot.data.data['max_exp'];
                  tglExp = exp.toDate();
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  header(urlImage),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0,  bottom: 15.0),
                    child: DottedBorder(
                      color: Colors.black,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(20.0),
                      strokeWidth: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          padding: EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('ID Promo', style: TextStyle(fontSize: 8.0, color: Colors.grey),),
                                  Text(widget.idPromo, style: TextStyle(fontWeight: FontWeight.w600),),
                                ],
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                onTap: (){
                                  Clipboard.setData(new ClipboardData(text: widget.idPromo)).then((onValue){
                                    setState(() {
                                      voucher = widget.idPromo;
                                    });
                                    key.currentState.showSnackBar(
                                        new SnackBar(content: new Text("Sudah Disalin"),));
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                                  decoration: BoxDecoration(color:Colors.blue,
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Text('SALIN PROMO', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  pointPromo(point, voucherStok),
                  Divider(color: Colors.grey,),
                  minmaxPromo(min, max, jenis),
                  Divider(color: Colors.grey,),
                  jenisPromo(jenis, stsPakai),
                  Divider(color: Colors.grey,),
                  keterangan(ket),
                  Divider(color: Colors.grey,),
                  ketentuan(),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0,  bottom: 15.0),
                    child: DottedBorder(
                      color: Colors.black,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(20.0),
                      strokeWidth: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          padding: EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Masa Berlaku Sampai', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),),
                              Expanded(child: Container()),
                              Text('${tglExp.day}.${tglExp.month}.${tglExp.year}', style: TextStyle(fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget ketentuan(){
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Ketentuan Promo', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('voucher').document(widget.idPromo).collection('ketentuan').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              List<Widget> dt = [];
              if (snapshot.connectionState==ConnectionState.active) {
                if (snapshot.data.documents.length>0) {
                  dt = snapshot.data.documents.map((f){
                    return Padding(
                      padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                      child: Text(f.data['ketentuan'].toString()),
                    );
                  }).toList();
                }
              }
              return Column(
                children: dt,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget jenisPromo(String ket, bool stsPakai){
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Jenis Voucher ${MediaQuery.of(context).size.width.toString()}', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                child: Text(ket.toString(),),
              )
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Stok Voucher', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                child: (stsPakai)?Text('Sekali Pakai',):Text('Pakai Berulang',),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget pointPromo(int point, int voucher){
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Point Voucher', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                child: Text('${point.toString()} Point',),
              )
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Stok Voucher', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                child: Text('${voucher.toString()} Vcr',),
              )
            ],
          ),
        ],
      ),
    );
  }
  
  Widget minmaxPromo(int min, int max, String jenis){
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (jenis=='Potongan Subtotal')?Text('Minimal Subtotal', style: TextStyle(color: Colors.grey, fontSize: 11.0)):
              (jenis=='Gratis Ongkir')?Text('Minimal Ongkir', style: TextStyle(color: Colors.grey, fontSize: 11.0)):Container(),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                child: Text('Rp.${idr(min).toString()}',),
              )
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              (jenis=='Potongan Subtotal')?Text('Max Subtotal', style: TextStyle(color: Colors.grey, fontSize: 11.0)):
              (jenis=='Gratis Ongkir')?Text('Max Ongkir', style: TextStyle(color: Colors.grey, fontSize: 11.0)):Container(),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                child: Text('Rp.${idr(max).toString()}',),
              )
            ],
          ),
        ],
      ),
    );
  }
  
  Widget keterangan(String ket){
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Keterangan Promo', style: TextStyle(color: Colors.grey, fontSize: 11.0)),
          Padding(
            padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
            child: Text(ket.toString(), textAlign: TextAlign.justify, style: TextStyle(height: 1.4)),
          )
        ],
      ),
    );
  }

  Widget header(String urlImage){
    return Container(
      height: MediaQuery.of(context).size.width-230,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ClipRRect(
        child: (urlImage!=null)?ShowImage(url: urlImage.toString(),):Container(),
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
          child: Center(child: CircularProgressIndicator()),
        ),
        filterQuality: FilterQuality.low,
        imageUrl: widget.url,
        fit: BoxFit.cover,
      ),
    );
  }
}