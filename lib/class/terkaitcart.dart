import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/class/terkaituser.dart';

class TerkaitCart {
  String idProduk, idDepot, idKategori;
  BuildContext context;
  int tambah = 1;
  int kurang = 1;
  CollectionReference cartCr = Firestore.instance.collection('cart');
  TerkaitCart({@required this.idDepot, @required this.idProduk, @required this.context, 
    this.tambah=1, this.kurang=1, @required this.idKategori});

  Future get addCart async{
    await TerkaitUser(context: context).getCekLogin.then((onValue) async {
      if (onValue!=null) {
        if (onValue.exists) {
          await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').document(idProduk).get().then((onValue2) async {
            if (!onValue2.exists) {
              await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').document(idProduk).setData({
                'value':tambah,
                'idkategori':idKategori
              });
              await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).setData({'created_at':DateTime.now(), 'updated_at':DateTime.now()});
            }else{
              await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').document(idProduk).updateData({
                'value':tambah+onValue2.data['value'],
                'idkategori':idKategori
              });
              await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).updateData({'updated_at':DateTime.now()});
            }
          });
        }
      }
    });
  }

  Future get minCart async{
    await TerkaitUser(context: context).getCekLogin.then((onValue) async {
      if (onValue!=null) {
        if (onValue.exists) {
          await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').document(idProduk).get().then((onValue2) async {
            if (onValue2.exists) {
              if(onValue2.data['value']>1){
                await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').document(idProduk).updateData({
                  'value':onValue2.data['value']-kurang,
                });
                await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).updateData({'updated_at':DateTime.now()});
              }else{
                await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').document(idProduk).delete();
                await cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).collection('detail_produk').getDocuments().then((onValue3){
                  if (onValue3.documents.length==0) {
                    cartCr.document(onValue.documentID).collection('detail_depot').document(idDepot).delete();
                  }
                });
              }
            }
          });
        }
      }
    });
  }
}