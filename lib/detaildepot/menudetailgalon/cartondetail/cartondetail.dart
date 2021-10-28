import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/class/terkaitcart.dart';
import 'package:need_customer/service/logincek.dart';

class CartOnDetail extends StatefulWidget {
  CartOnDetail({Key key, @required this.habis, @required this.idKategori, @required this.idDepot, @required this.idProduk}) : super(key: key);
  final bool habis;
  final String idProduk, idDepot, idKategori;
  @override
  _CartOnDetailState createState() => _CartOnDetailState();
}

class _CartOnDetailState extends State<CartOnDetail> {
  bool loadingTamabahCart = false;
  CollectionReference cartCr = Firestore.instance.collection('cart');

  @override
  Widget build(BuildContext context) {
    return LoginCek(lanjutSaja: true, fcLogin: (dataLogin, dataUser){
      if (dataUser!=null) {
        return StreamBuilder<DocumentSnapshot>(
          stream: cartCr.document(dataUser.data.documentID).collection('detail_depot').document(widget.idDepot).collection('detail_produk').document(widget.idProduk).snapshots() ,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if (snapshot.connectionState==ConnectionState.active) {
              if (snapshot.data.exists) {
                return ada(snapshot.data.data['value']);
              }else{
                return baru();
              }
            }
            return baru();
          },
        );
      }
      return baru();
    });
  }

  baru(){
    return GestureDetector(
      onTap: () async {
        if(widget.habis){
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            tittle: 'Peringatan',
            desc: 'Produk Habis',
            btnCancelOnPress: () {},
            btnCancelText: 'OKE'
          ).show();
        }else{
          if (!loadingTamabahCart) {
            setState(()=>loadingTamabahCart=true);
            await TerkaitCart(idDepot:widget.idDepot, idProduk:widget.idProduk, context: context, idKategori: widget.idKategori).addCart.then((onValue){
              // if (onValue) {
                
              // }
            });
            setState(()=>loadingTamabahCart=false);
          }
        }
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(color: (loadingTamabahCart)?Colors.grey[800]:(widget.habis)?Colors.red:Colors.green, borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(color: Colors.black45.withOpacity(.3), blurRadius: 2.0)
                ]
              ),
              child: Text((loadingTamabahCart)?'....':(widget.habis)?'Habis':'Tambah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
            )
          ],
        ),
      ),
    );
  }

  ada(int value){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(child: Container()),
          GestureDetector(
            onTap: () async {
              if(widget.habis){
                AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.ERROR,
                  tittle: 'Peringatan',
                  desc: 'Produk Habis',
                  btnCancelOnPress: () {},
                  btnCancelText: 'OKE'
                ).show();
              }else{
                if (!loadingTamabahCart) {
                  setState(()=>loadingTamabahCart=true);
                  await TerkaitCart(idDepot:widget.idDepot, idProduk:widget.idProduk, idKategori: widget.idKategori, context: context).minCart.then((onValue){
                    // if (onValue) {

                    // }
                  });
                  setState(()=>loadingTamabahCart=false);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(color: (loadingTamabahCart)?Colors.grey[800]:(widget.habis)?Colors.red:Colors.red, borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(color: Colors.black45.withOpacity(.3), blurRadius: 2.0)
                ]
              ),
              child: Text((loadingTamabahCart)?'.':(widget.habis)?'Habis':'-', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
            )
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            padding: EdgeInsets.only(left:10.0, right: 10.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
            ),
            child: Text(value.toString()),
          ),
          GestureDetector(
            onTap: () async {
              if(widget.habis){
                AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.ERROR,
                  tittle: 'Peringatan',
                  desc: 'Produk Habis',
                  btnCancelOnPress: () {},
                  btnCancelText: 'OKE'
                ).show();
              }else{
                if (!loadingTamabahCart) {
                  setState(()=>loadingTamabahCart=true);
                  await TerkaitCart(idDepot:widget.idDepot, idProduk:widget.idProduk, idKategori: widget.idKategori, context: context).addCart.then((onValue){
                    // if (onValue) {
                      
                    // }
                  });
                  setState(()=>loadingTamabahCart=false);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(color: (loadingTamabahCart)?Colors.grey[800]:(widget.habis)?Colors.red:Colors.green, borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(color: Colors.black45.withOpacity(.3), blurRadius: 2.0)
                ]
              ),
              child: Text((loadingTamabahCart)?'.':(widget.habis)?'Habis':'+', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
            )
          ),
        ],
      ),
    );
  }
}