import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class StatusUpgrade extends StatefulWidget {
  StatusUpgrade({Key key, @required this.nama, @required this.url, @required this.deskripsi, @required this.status, @required this.harga, @required this.namaProduk, @required this.idUser}) : super(key: key);
  final String nama;
  final String deskripsi;
  final int harga;
  final String namaProduk;
  final String status;
  final String idUser;
  final String url;

  @override
  _StatusUpgradeState createState() => _StatusUpgradeState();
}

class _StatusUpgradeState extends State<StatusUpgrade> {
  bool loading = false;
  @override
  void initState() {
    loading = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0, right: 15.0),
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Upgrade Akun Anda', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: Text('Status Upgrade Akun', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: Text('Nama Pengguna : ' + widget.nama.toString(), style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0, bottom: 5.0),
                    child: Text('Data Produk', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Container(width: 80.0, height: 80.0, margin: EdgeInsets.only(right: 10.0), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: (widget.url==null)?Container():Image.network(widget.url.toString(), fit: BoxFit.cover,),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width-120,
                              child: Text(widget.namaProduk.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),)),
                            Container(
                              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width-120,
                                // color: Colors.red,
                                child: Text(widget.deskripsi.toString(), maxLines: 2, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400), textAlign: TextAlign.justify,))),
                            Text('Rp. ${idr(widget.harga).toString()}', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Text('1x24 jam anda akan dihubungi admin', style: TextStyle(fontSize: 13.0),),
            ),
            Divider(),
            Column(
              children: <Widget>[
                // Text('status', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),),
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0, right: 15.0),
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    decoration: BoxDecoration(color: (widget.status.toString()=='SEDANG DIKIRIM')?Colors.blue:(widget.status.toString()=='SELESAI')?Colors.orange:Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                    child: Center(child: Text(widget.status.toString(), style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white),))),
                ),
                (widget.status.toString()!='MENUNGGU KONFIRMASI')?Container():GestureDetector(
                  onTap: (){
                    AwesomeDialog(context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      tittle: 'Info',
                      desc: 'Yakin Ingin Membatalkan?',
                      btnOkText: 'BATALKAN',
                      btnOkOnPress: () async {
                        if (!loading) {
                          setState(()=>loading = true);
                          await Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).collection('databarang').document().delete().then((onValue) async {
                            await Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).delete().then((onValue){

                            });
                          });
                          setState(()=>loading = false);
                        }
                      },
                      btnCancelText: 'KEMBALI',
                      btnCancelOnPress: () {

                      },
                    ).show();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    margin: EdgeInsets.only(left: 15.0, top: .0, bottom: 15.0, right: 15.0),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0), boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 3.0)
                    ]),
                    child: Center(child: Text('BATALKAN', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: Colors.white),))),
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