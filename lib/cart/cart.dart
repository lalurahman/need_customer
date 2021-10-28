import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:need_customer/cart/detailpesanan/detailpesanan.dart';
import 'package:need_customer/cart/express/express.dart';
import 'package:need_customer/cart/fiturlain/fiturlain.dart';
import 'package:need_customer/cart/kurirtersedia/kurirtersedia.dart';
import 'package:need_customer/cart/mapcart/mapcart.dart';
import 'package:need_customer/cart/totalpesanan/totalpesanan.dart';
import 'package:need_customer/cart/voucher/voucher.dart';
import 'package:need_customer/service/depotcek.dart';
import 'package:need_customer/service/logincek.dart';
import 'package:need_customer/theme/companycolors.dart';

class Cart extends StatefulWidget {
  Cart({Key key, @required this.idDepot, @required this.myPosition}) : super(key: key);
  final String idDepot;
  final Position myPosition;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return DepotCek(
      idDepot: widget.idDepot,
      child: LoginCek(
        fcLogin: (AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot>dataUser){
          if (dataLogin!=null&&dataUser!=null) {
            return wdg(dataUser.data.documentID,dataUser);
          }
          return Scaffold();
        }
      ),
    );
  }

  Widget wdg(String idUser, AsyncSnapshot<DocumentSnapshot>dataUser){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: getNamaDepot(),
        actions: <Widget>[
          Express(idDepot: widget.idDepot, idUser: idUser,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MapCart(idDepot: widget.idDepot, idUser: idUser, myPosition:widget.myPosition),
            KurirTersedia(idDepot: widget.idDepot, idUser: idUser,),
            Voucher(idDepot: widget.idDepot, idUser: idUser,),
            DetailPesanan(idDepot: widget.idDepot, idUser: idUser,),
            FiturLain(idDepot: widget.idDepot, idUser: idUser,),
            TotalPesanan(idDepot: widget.idDepot, idUser: idUser, dataUser:dataUser),
            Container(height: 20.0,)
          ],
        ),
      ),
    );
  }

  Widget getNamaDepot(){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_mitra').document(widget.idDepot).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            return Text('${snapshot.data.data['nama_depot']}');
          }
        }
        return Container();
      },
    );
  }
}