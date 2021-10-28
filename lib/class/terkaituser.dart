import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TerkaitUser {
  String idDepot='';
  BuildContext context;
  bool showPeringatan=true;
  CollectionReference customerRef = Firestore.instance.collection('data_customer');

  TerkaitUser({this.idDepot='', @required this.context, this.showPeringatan=true});
  Future<bool> get getWishlist async{
    bool status = false;
    await getCekLogin.then((onValue) async {
      if (onValue!=null) {
        if (onValue.exists) {
          DocumentReference wishlistDr = customerRef.document(onValue.documentID).collection('wishlist').document(idDepot);
          await wishlistDr.get().then((onValue2) async {
            bool sts = false;
            if (onValue2.exists) {
              sts=onValue2.data['value'];
            }
            status=sts;
          }).timeout(Duration(seconds: 5), onTimeout: (){
            peringatan('Time Out');
          });
        }
      }
    });
    return status;
  }

  Future get setWishlist async{
    await getCekLogin.then((onValue) async {
      if (onValue!=null) {
        if (onValue.exists) {
          DocumentReference wishlistDr = customerRef.document(onValue.documentID).collection('wishlist').document(idDepot);
          await wishlistDr.get().then((onValue2) async {
            if (onValue2.exists) {
              await wishlistDr.updateData({
                'value':(onValue2.data['value'])?false:true,
                'updated_at':DateTime.now()
              });
              sukses('Wishlist telah diubah');
            }else{
              await wishlistDr.setData({
                'value':true,
                'updated_at':DateTime.now(),
                'created_at':DateTime.now(),
              });
              sukses('Wishlist telah diubah');
            }
          });
        }
      }
    });
  }

  Future<DocumentSnapshot> get getCekLogin async {
    DocumentSnapshot userData;
    await FirebaseAuth.instance.currentUser().then((onValue) async {
      if (onValue!=null) {
        await customerRef.document(onValue.uid).get().then((onValue2){
          if (onValue2.exists) {
            userData=onValue2;
          }else{
            peringatan('User Anda Bermasalah');
          }
        });
      }else{
        peringatan('Anda Belum Login');
      }
    });
    return userData;
  }

  peringatan(String title){
    if (showPeringatan) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        tittle: 'Peringatan',
        desc: title,
        btnCancelOnPress: () {},
        btnCancelText: 'OKE',
      ).show();
    }
  }

  sukses(String title){
    if (showPeringatan) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        tittle: 'INFO',
        desc: title,
        btnOkOnPress: () {},
        btnOkText: 'OKE',
      ).show();
    }
  }
}