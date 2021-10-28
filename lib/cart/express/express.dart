import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Express extends StatefulWidget {
  Express({Key key, @required this.idDepot, this.idUser}) : super(key: key);
  final String idDepot;
  final String idUser;
  @override
  _ExpressState createState() => _ExpressState();
}

class _ExpressState extends State<Express> {
  bool isSwitched = false;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    isSwitched = false;
    loading = false;
    getExpress();
  }


  getExpress(){
    Stream<DocumentSnapshot> jadi2 = Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots();
    jadi2.listen((onData){
      if (!mounted) return;
      if (onData.exists) {
        setState(() {
          isSwitched = (onData.data['express']!=null)?onData.data['express']:false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) async {
        if (!mounted) return;
        if (!loading) {
          setState(() {
            loading=true;
          });
          await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
            'express':value,
            'updated_at':DateTime.now(),
          }).then((onValue){
            if (!mounted) return;
            setState(() {
              isSwitched = value;
              loading=false;
            });
          });
        }
      },
      activeTrackColor: Colors.green[400],
      activeColor: Colors.green,
      inactiveThumbColor: Colors.white,
      // inactiveTrackColor: Colors.yellow[900],
    );
  }
}