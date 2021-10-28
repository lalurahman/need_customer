import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:need_customer/detaildepot/detaildepot.dart';
import 'package:need_customer/theme/companycolors.dart';

class WishList extends StatefulWidget {
  WishList({Key key, @required this.idUser}) : super(key: key);
  final String idUser;
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<DocumentSnapshot> data = [];
  @override
  void initState() { 
    super.initState();
    getWishlistStrm = getWishlist();
    getWishlistStrm.resume();
  }

  @override
  void dispose() { 
    super.dispose();
    getWishlistStrm.cancel();
  }

  StreamSubscription<QuerySnapshot> getWishlistStrm;
  StreamSubscription<QuerySnapshot> getWishlist(){
    return Firestore.instance.collection('data_customer').document(widget.idUser).collection('wishlist').snapshots().listen((onData){
      if (!mounted) return;
        setState(() {
          data = [];
        });
      if (onData.documents.length>0) {
        if (!mounted) return;
        setState(() {
          data = onData.documents;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Wishlist'),
      ),
      body: (data.length<=0)?Container():
      Column(
        children: data.map((f){
          return wdg(f.documentID);
        }).toList(),
      ),
    );
  }

  Widget wdg(String idDepot){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_mitra').document(idDepot.toString()).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            if (snapshot.data.data['aktifasi']!=null)
            if (snapshot.data.data['aktifasi']==true)
            return GestureDetector(
              onTap: () async {
                if(snapshot.data.data['status_online']){
                  ClipboardData dataP = await Clipboard.getData('text/plain');
                  await Firestore.instance.collection('voucher').document(dataP.text.toString()).get().then((onValue) async {
                    if (onValue.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailDepot(id:idDepot.toString(), voucher:dataP.text.toString(), myPosition:null)),
                      );
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailDepot(id:idDepot.toString(), voucher:null, myPosition:null)),
                      );
                    }
                  });
                }else{
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.ERROR,
                    tittle: 'Peringatan',
                    desc: 'Maaf depot sedang tutup',
                    btnOkOnPress: () {},
                  ).show();
                }
              },
              child: Container(
                color: Colors.red.withOpacity(.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nama Depot', style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                                    (snapshot.data.data['status_online'])?Container():
                                    Text('  TUTUP', style: TextStyle(fontSize: 12.0, color: Colors.red, fontWeight: FontWeight.w800),),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width-50,
                                child: Text(snapshot.data.data['nama_depot'].toString(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 15.0),)),
                            ],
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}