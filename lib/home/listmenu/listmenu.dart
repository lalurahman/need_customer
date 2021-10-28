import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListMenu extends StatefulWidget {
  @override
  _ListMenuState createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          cardnya(Icons.local_grocery_store,'Pesan Galon', Colors.green, true,() async {
            await Firestore.instance.collection('data_mitra').getDocuments().then((onValue){
              if (onValue.documents.length==0) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.INFO,
                  tittle: 'Peringatan',
                  desc:   'Maaf Data Mitra Masih Kosong',
                  btnOkOnPress: () {},
                ).show();
              }else{
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ListDepot(ufOnly: false, roOnly: false, alOnly: false, brOnly: false,)),
                // );
              }
            });
          }),
          cardnya(Icons.local_drink,'Air Kemasan', Colors.lime, false,(){
            AwesomeDialog(context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'Peringatan',
              desc: 'Maaf Fitur ini belum Dapat Digunakan',
              btnCancelText: 'TUTUP',
              btnCancelOnPress: () {},
              // btnOkOnPress: () {}
            ).show();
          }),
          cardnya(Icons.local_play,'Air Branded', Colors.pinkAccent, false,(){
            AwesomeDialog(context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'Peringatan',
              desc: 'Maaf Fitur ini belum Dapat Digunakan',
              btnCancelText: 'TUTUP',
              btnCancelOnPress: () {},
              // btnOkOnPress: () {}
            ).show();
          }),
          cardnya(Icons.apps,'Lainnya', Colors.grey, false,(){
            AwesomeDialog(context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'Peringatan',
              desc: 'Maaf Fitur ini belum Dapat Digunakan',
              btnCancelText: 'TUTUP',
              btnCancelOnPress: () {},
              // btnOkOnPress: () {}
            ).show();
          }),
        ],
      ),
    );
  }

  Widget cardnya(IconData icon, String title, Color clr, bool fav, Function fc){
    return Expanded(
      child: GestureDetector(
        onTap: fc,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    width: 50.0, height: 50.0,
                    decoration: BoxDecoration(color: clr, borderRadius: BorderRadius.circular(100.0)),
                    child: Container(
                      child: Icon(icon, color: Colors.white, size: 30.0,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: Text(title, style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                  )
                ],
              ),
            ),
            (fav)?
            Positioned(
              top: 0,
              right: 12,
              child: Container(
                // decoration: BoxDecoration(color: Colors.red),
                child: Center(
                  child: Icon(Icons.star, color: Colors.orange,),
                ),
              ),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
