import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:need_customer/cart/lanjuttransaksi/lanjuttransaksi.dart';

class TotalPesanan extends StatefulWidget {
  TotalPesanan({Key key, @required this.idDepot, @required this.idUser, @required this.dataUser}) : super(key: key);
  final String idDepot, idUser;
  final AsyncSnapshot<DocumentSnapshot>dataUser;
  @override
  _TotalPesananState createState() => _TotalPesananState();
}

class _TotalPesananState extends State<TotalPesanan> {
  int subTotalInt = 0;
  int subTotalOldInt = 0;
  int finTotalInt = 0;
  int ongkirInt = 0;
  int ongkirOldInt = 0;
  int potonganSubTotalInt = 0;
  int minOngkir = 0;
  int maxOngkir = 0;
  int lantaiTotInt = 0;
  int lantaiInt = 0;
  int perLantaiInt = 0;
  int jemputAntarInt = 0;
  int potonganPointKuInt = 0;
  int pointKuInt = 0;
  int chrgPerITem = 0;
  bool gratisOngir = false;
  bool voucherEnable = false;
  bool express = false;
  bool jemputAntar = false;
  String kodeVoucher;
  GeoPoint latlong;
  int jmlItem = 0;
  int jarakInt = 0;
  String alamat;
  List<Map<String, dynamic>> listProduk;

  // String
  // bool
  // int
  // List<String> a = [31];
  // Map b = {'a':'a'};

  @override
  void dispose() { 
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    subTotalInt = 0;
    subTotalOldInt = 0;
    finTotalInt = 0;
    chrgPerITem = 0;
    ongkirInt = 0;
    ongkirOldInt = 0;
    potonganSubTotalInt = 0;
    minOngkir = 0;
    maxOngkir = 0;
    lantaiTotInt = 0;
    lantaiInt = 0;
    perLantaiInt = 0;
    jemputAntarInt = 0;
    pointKuInt = 0;
    potonganPointKuInt = 0;
    gratisOngir = false;
    voucherEnable = false;
    express = false;
    jemputAntar = false;
    kodeVoucher=null;
    jmlItem = 0;
    jarakInt = 0;
    latlong = null;
    alamat = null;
    getTotal();
  }
  
  void defaultTotal(DocumentSnapshot onData3){
    setState(() {
      ongkirInt=(onData3.data['ongkir']!=null)?onData3.data['ongkir']:0;
      ongkirOldInt=(onData3.data['ongkir']!=null)?onData3.data['ongkir']:0;
      finTotalInt = subTotalInt+ongkirInt;
      gratisOngir = false;
      kodeVoucher = (onData3.data['voucher']!=null)?onData3.data['voucher']:null;
      lantaiInt = (onData3.data['lantai']!=null)?onData3.data['lantai']:0;
      jemputAntar = (onData3.data['jemput_antar']!=null)?onData3.data['jemput_antar']:false;
      express = (onData3.data['express']!=null)?onData3.data['express']:false;
      jarakInt = (onData3.data['jarak_kilo']!=null)?onData3.data['jarak_kilo']:0;
      latlong = (onData3.data['latlong']!=null)?onData3.data['latlong']:null;
      alamat = (onData3.data['alamat']!=null)?onData3.data['alamat']:null;
      voucherEnable = false;
      potonganSubTotalInt = 0;
      minOngkir = 0;
      maxOngkir = 0;
      jemputAntarInt = 0;
      lantaiTotInt = 0;
      perLantaiInt = 0;
      subTotalInt = ((subTotalOldInt-potonganSubTotalInt)<0)?0:subTotalOldInt-potonganSubTotalInt;
      finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
    });
  }

  void getTotal() {
    Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').snapshots().listen((onData){
      if (!mounted) return;
      setState(() {
        jmlItem=0;
        chrgPerITem=0;
      });
      if (onData.documents.length>0) {
        int i = 0;
        if (!mounted) return;
        setState(() {
          listProduk=[];        
        });
        int noo = 0;
        onData.documents.forEach((f){
          jmlItem=jmlItem+f.data['value'];
          noo++;
          if(noo==onData.documents.length){
            getChargerPerItem();
          }
          Stream<DocumentSnapshot> jadi = Firestore.instance.collection('kategori').document(widget.idDepot).collection('detail_kategori').document(f.data['idkategori']).collection('produk').document(f.documentID).snapshots();
          jadi.listen((onData3){
            if (!mounted) return;
            if (onData3.exists) {
              int ttl = 0;
              int harga = onData3.data['harga_produk'];
              int discount = (onData3.data['discount']==null)?0:onData3.data['discount'];
              double discountFinal = .0;
              if (discount>0) {
                discountFinal = discount / 100 * onData3.data['harga_produk'];
                ttl = (onData3.data['harga_produk'] - discountFinal).round() * f.data['value'];
                harga = (onData3.data['harga_produk'] - discountFinal).round();
              }else{
                ttl = onData3.data['harga_produk']*f.data['value'];
              }
              setState(() {
                listProduk.add({'id_produk':f.documentID, 'idkategori':f.data['idkategori'], 'value':f.data['value'], 'harga_produk':onData3.data['harga_produk'], 
                  'discount':(onData3.data['discount']!=null)?onData3.data['discount']:0, 'nama_produk':onData3.data['nama_produk'], 'total':ttl, 'harga_discount':harga,
                });
              });
              i=i+1;
            }
          });
        });
      }
    });
    
    getSubtotal();
    
    Stream<DocumentSnapshot> jadi2 = Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots();
    jadi2.listen((onData3) async {
      if (onData3.exists) {
        if (!mounted) return;
        defaultTotal(onData3);
        if(onData3.data['voucher']!=null){
          // Script untuk menentukan promo atau voucher
          Firestore.instance.collection('voucher').document(onData3.data['voucher'].toString()).snapshots().listen((onData5) async {
            if (onData5.exists) {
              Firestore.instance.collection('data_customer').document(widget.idUser).snapshots().listen((onData34) async {
                if(!mounted)return;
                setState((){pointKuInt = 0; potonganPointKuInt=0;});
                if (onData34.exists) {
                  if(!mounted)return;
                  setState((){pointKuInt = onData34.data['point'];});
                  if (onData34.data['point']>=onData5.data['point']) {
                    setState((){potonganPointKuInt = onData34.data['point'] - onData5.data['point'];});
                    switch (onData5.data['jenis'].toString()) {
                      case 'gratis ongkir':{
                        Timestamp tglMax = onData5.data['max_exp'];
                        DateTime tglMaxF = tglMax.toDate();
                        if(!mounted)return;
                        setState(() {
                          maxOngkir=onData5.data['max_ongkir'];
                          minOngkir=onData5.data['min_ongkir'];
                        });
                        if (onData5.data['stok']>0&&onData5.data['status']) {
                          if (onData5.data['max_ongkir']>=((onData3.data['ongkir']!=null)?onData3.data['ongkir']:0)&&onData5.data['min_ongkir']<=((onData3.data['ongkir']!=null)?onData3.data['ongkir']:0)) {
                            if (onData5.data['sekali_pakai']) {
                              await Firestore.instance.collection('final_transaksi').where('id_user', isEqualTo: widget.idUser).where('voucher', isEqualTo: onData5.documentID).getDocuments().then((onValue22){
                                if(onValue22.documents.length>0){defaultTotal(onData3);}else{
                                  if(!mounted)return;
                                  setState(() {
                                    ongkirInt=0;
                                    finTotalInt = subTotalOldInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
                                    gratisOngir = true;
                                    voucherEnable = true;
                                  });
                                }
                              });
                            }else{
                              if(!mounted)return;
                              setState(() {
                                ongkirInt=0;
                                finTotalInt = subTotalOldInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
                                gratisOngir = true;
                                voucherEnable = true;
                              });
                            }
                          }else{defaultTotal(onData3);}
                        }else{defaultTotal(onData3);}
                      }
                      break;
                      case 'potongan subtotal':{
                        Timestamp tglMax = onData5.data['max_exp'];
                        DateTime tglMaxF = tglMax.toDate();
                        // if (DateTime.parse(tglMaxF.toString())<DateTime.parse(DateTime.now().toString())) {
                        if (onData5.data['stok']>0&&onData5.data['status']) {
                            // print(subTotalInt);
                          if (onData5.data['max_subtotal']>=subTotalInt&&onData5.data['min_subtotal']<=subTotalInt) {
                            if (onData5.data['sekali_pakai']) {
                              await Firestore.instance.collection('final_transaksi').where('id_user', isEqualTo: widget.idUser).where('voucher', isEqualTo: onData5.documentID).getDocuments().then((onValue22){
                                if(onValue22.documents.length>0){defaultTotal(onData3);}else{
                                  if(!mounted)return;
                                  setState(() {	
                                    potonganSubTotalInt = onData5.data['potongan'];
                                    subTotalInt = ((subTotalOldInt-potonganSubTotalInt)<0)?0:subTotalOldInt-potonganSubTotalInt;
                                    finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
                                    voucherEnable = true;
                                  });
                                }
                              });
                            }else{
                              if(!mounted)return;
                              setState(() {	
                                potonganSubTotalInt = onData5.data['potongan'];	
                                subTotalInt = ((subTotalOldInt-potonganSubTotalInt)<0)?0:subTotalOldInt-potonganSubTotalInt;	
                                finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;	
                                voucherEnable = true;	
                              });
                            }
                          }else{defaultTotal(onData3);}
                        }else{defaultTotal(onData3);}
                      }
                      break;
                      default:defaultTotal(onData3);
                      break;
                    }
                  }else{defaultTotal(onData3);}
                }else{defaultTotal(onData3);}
              });
            }
          });
        }
        
        getExpress(onData3);
        
      }
    });
  }

  getChargerPerItem(){
    if (jmlItem>1) {
      Stream<DocumentSnapshot> jadi = Firestore.instance.collection('ketentuan').document("charger_per_item").snapshots();
      jadi.listen((onData){
        if (onData.exists) {
          if(!mounted)return;
          setState(() {
            chrgPerITem=(jmlItem*onData.data['value'])-onData.data['value'];
          });
        }
      }).resume();
    }

  }
  void getExpress(DocumentSnapshot onData3){
    Stream<DocumentSnapshot> jadi = Firestore.instance.collection('ketentuan').document('ongkir').snapshots();
    jadi.listen((onData){
      if (!mounted) return;
      if (onData.exists) {
        if (onData3.data['lantai']!=null) {
          if (onData3.data['lantai']>0) {
            if (onData.exists) {
              if(onData.data['per_lantai']!=null){
                setState(() {
                  perLantaiInt = onData.data['per_lantai'];
                  lantaiTotInt = onData.data['per_lantai']*lantaiInt;
                  finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
                });
              }
            }
          }
        }
        if (jemputAntar) {
          setState(() {
            jemputAntarInt = ((onData3.data['jarak_kilo']!=null)?onData3.data['jarak_kilo']:0)*onData.data['jemput_antar'];
            finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
          });
        }
        if (express) {
          if(onData3.data['jarak_kilo']!=null){
            setState(() {
              ongkirOldInt=onData3.data['jarak_kilo']*onData.data['express'];              
            });
            if (!gratisOngir) {
              setState(() {
                ongkirInt=onData3.data['jarak_kilo']*onData.data['express'];
                finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
              });
            }else{
              if (maxOngkir>=ongkirOldInt && minOngkir<=ongkirOldInt) {
                setState(() {
                  ongkirInt=0;
                  finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
                });
              }else{
                setState(() {
                  gratisOngir = false;
                  voucherEnable = false;
                  ongkirInt=onData3.data['jarak_kilo']*onData.data['express'];
                  finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
                });
              }
            }
          }
        }
      }
    });
  }
  void getSubtotal(){
    Stream<QuerySnapshot> jadi = Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).collection('detail_produk').snapshots();
    jadi.listen((onData){
      if (!mounted) return;
      if (onData.documents.length>0) {
        int harga=0;
        onData.documents.forEach((f){
          Firestore.instance.collection('kategori').document(widget.idDepot).collection('detail_kategori').document(f.data['idkategori']).collection('produk').document(f.documentID).snapshots().listen((onData2){
            if (!mounted) return;
            if (onData2.exists) {
              int discount = (onData2.data['discount']==null)?0:onData2.data['discount'];
              double discountFinal = .0;
              if (discount>0) {
                discountFinal = discount / 100 * onData2.data['harga_produk'];
                harga = harga + ((onData2.data['harga_produk'] - discountFinal).round() * f.data['value']);
                // print((onData2.data['harga_produk'] - discountFinal).round());
              }else{
                harga = harga + onData2.data['harga_produk']*f.data['value'];
              }
              setState((){
                subTotalInt = harga;
                subTotalOldInt = harga;
                subTotalInt = ((subTotalInt-potonganSubTotalInt)<0)?0:subTotalInt-potonganSubTotalInt;                 
                
                finTotalInt = subTotalInt+ongkirInt+lantaiTotInt+jemputAntarInt+chrgPerITem;
              });
            }
          });            
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        wdgExpress(),
        voucher(),
        wdg('Charger Per Item', chargePerItem(), merah: true),
        (!jemputAntar)?Container():
        wdg('Layanan Jemput Antar', jemputAntarWdg()),
        (lantaiInt==0)?Container():
        wdg('Rp. ${idr(perLantaiInt)} / Lantai', lantai()),
        (potonganSubTotalInt>0)?
        wdg('(Potongan) Harga', subTotal()):
        wdg('Harga', subTotal()),
        (gratisOngir)?
        wdg('(Gratis) Ongkir', ongkir()):
        wdg('Ongkir', ongkir()),
        wdg('Total', finTotal()),
        LanjutTransaksi(idDepot: widget.idDepot, idUser: widget.idUser,
          subTotalInt:subTotalInt, subTotalOldInt:subTotalOldInt, finTotalInt:finTotalInt, chrgPerITem:chrgPerITem,
          ongkirInt:ongkirInt, ongkirOldInt:ongkirOldInt, potonganSubTotalInt:potonganSubTotalInt,
          minOngkir:minOngkir, maxOngkir:maxOngkir, lantaiTotInt:lantaiTotInt, lantaiInt:lantaiInt,
          perLantaiInt:perLantaiInt, jemputAntarInt:jemputAntarInt, gratisOngir:gratisOngir, voucherEnable:voucherEnable,
          express:express, jemputAntar:jemputAntar, kodeVoucher:kodeVoucher,jmlItem:jmlItem, jarakInt:jarakInt,
          latlong:latlong, alamat:alamat, listProduk:listProduk, dataUser: widget.dataUser, potonganPointKuInt:potonganPointKuInt,
          pointKuInt:pointKuInt
        )
      ],
    );
  }

  Widget chargePerItem(){
    return Text('Rp. ${idr(chrgPerITem).toString()}', style: TextStyle(color: Colors.red), textAlign: TextAlign.end,);
  }

  Widget jemputAntarWdg(){
    return Text('Rp. ${idr(jemputAntarInt)}', textAlign: TextAlign.end,);
  }

  Widget lantai(){
    return Text('Rp. ${idr(lantaiTotInt)}', textAlign: TextAlign.end,);
  }

  Widget wdgExpress(){
    if(express){
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        height: 30.0,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Icon(Icons.timer, color: Colors.white, size: 15.0,),
            //     Text(' Anda Mengaktifkan Fitur Express!! ', style: TextStyle(color: Colors.white,)),
            //     Icon(Icons.timer, color: Colors.white, size: 15.0,)
            //   ],
            // ),
            Text('EXPRESS MERUPAKAN LAYANAN PENGANTARAN CEPAT', style: TextStyle(color: Colors.white, fontSize: 10.0)),
          ],
        ),
      );
    }
    return Container();
  }

  Widget voucher(){
    if (kodeVoucher!=null) {
      if (!voucherEnable) {
        return Padding(
          padding: const EdgeInsets.only(bottom:10.0, right: 10.0),
          child: Text('Voucher Tidak Dapat Digunakan', textAlign: TextAlign.end, style: TextStyle(color: Colors.red, fontSize: 10.0),),
        );
      }
    }
    return Container();
  }

  Widget subTotal() {
    if (potonganSubTotalInt>0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('Rp. ${idr(subTotalOldInt)}', textAlign: TextAlign.end, style: TextStyle(decoration: TextDecoration.lineThrough,)),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Text('Rp. ${idr(subTotalInt)}', textAlign: TextAlign.end, style: TextStyle(color: Colors.green),),
          ),
        ],
      );    
    }else{
      return Text('Rp. ${idr(subTotalOldInt)}', textAlign: TextAlign.end,);    
    }
  }

  Widget finTotal(){
    return Text('Rp. ${idr(finTotalInt)}', textAlign: TextAlign.end,);
  }

  Widget ongkir(){
    if (gratisOngir) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('Rp. ${idr(ongkirOldInt)}', textAlign: TextAlign.end, style: TextStyle(color: (express)?Colors.orange:Colors.black, decoration: TextDecoration.lineThrough,)),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Text('- Rp. ${idr(ongkirInt)}', textAlign: TextAlign.end, style: TextStyle(color: Colors.green),),
          ),
        ],
      );    
    }else{
      return Text('Rp. ${idr(ongkirInt)}', textAlign: TextAlign.end, style: TextStyle(color: (express)?Colors.orange:Colors.black),);    
    }
  }

  Widget wdg(String title, Widget total, {bool merah=false}){
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Container()),
          Text('${title.toString()} : ', style: TextStyle(fontWeight: FontWeight.w600, color: (merah)?Colors.red:Colors.black),),
          Container(
            width: 100.0,
            child: total,
          )
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