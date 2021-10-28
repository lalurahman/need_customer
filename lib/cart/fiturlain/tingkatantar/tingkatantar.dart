import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/modalbottom.dart';

class TingkatAntar extends StatefulWidget {
  TingkatAntar({Key key, @required this.idDepot, @required this.idUser}) : super(key: key);
  final String idDepot, idUser;

  @override
  _TingkatAntarState createState() => _TingkatAntarState();
}

class _TingkatAntarState extends State<TingkatAntar> {
  int lantai = 0;
  bool loading = false;
  @override
  void initState() { 
    super.initState();
    lantai = 0;
    loading = false;
    getLantai();
  }
  getLantai(){
    Stream<DocumentSnapshot> jadi = Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots();
    jadi.listen((onData){
      if (!mounted) return;
      if (onData.exists) {
        if (onData.data['lantai']!=null) {
          setState(() {
            lantai=onData.data['lantai'];
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 3.0),
      decoration: BoxDecoration(
        color: Colors.grey[200]
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                child: Text('Antar Kelantai Berapa?', style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text('Pesanan Anda Mau Diantarkan Kelantai Berapa?', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 11),),
              ),
            ],
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: (){
              ModalBottom().mainBottomSheet(context, tbhLantai());
            },
            child: Container(
              margin: const EdgeInsets.only(right:10.0),
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4.0)
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text('Lantai', style: TextStyle(fontSize: 8.0, color: Colors.black54),),
                  Text(lantai.toString(), style: TextStyle(fontSize: 20.0, color: Colors.black54),),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  Widget tbhLantai(){
    return Container(
      height: 100.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
            child: Text('Antar Kelantai Berapa?', style: TextStyle(fontWeight: FontWeight.w600),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('Pesanan Anda Mau Diantarkan Kelantai Berapa?', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 11),),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    if (!loading) {
                      setState(()=>loading=true);
                      if (lantai!=0) {
                        await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
                          'lantai':lantai-1
                        });
                      }
                      setState(()=>loading=false);
                    }
                  },
                  child: Container(
                    width: 30.0, height: 30.0,
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Center(child: Text('-', style: TextStyle(color: Colors.white),)),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                    int lt=0;
                    if (snapshot.connectionState==ConnectionState.active) {
                      if (snapshot.data.exists) {
                        if (snapshot.data['lantai']!=null) {
                          lt=snapshot.data['lantai'];
                        }
                      }
                    }
                    return Container(
                      width: 50.0,
                      height: 30.0,
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: Center(child: Text(lt.toString()),),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    if (!loading) {
                      setState(()=>loading=true);
                      await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
                        'lantai':lantai+1
                      });
                      setState(()=>loading=false);
                    }
                  },
                  child: Container(
                    width: 30.0, height: 30.0,
                    decoration: BoxDecoration(color: Colors.green),
                    child: Center(child: Text('+', style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}