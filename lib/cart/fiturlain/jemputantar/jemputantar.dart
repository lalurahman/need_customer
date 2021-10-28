import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JemputAntar extends StatefulWidget {
  JemputAntar({Key key, @required this.idDepot, @required this.idUser}) : super(key: key);
  final String idDepot, idUser;

  @override
  _JemputAntarState createState() => _JemputAntarState();
}

class _JemputAntarState extends State<JemputAntar> {
  int lantai = 0;
  bool loading = false;
  bool isSwitched=false;
  @override
  void initState() { 
    super.initState();
    lantai = 0;
    loading = false;
    isSwitched=false;
    getJemputAntar();
  }
  getJemputAntar(){
    Stream<DocumentSnapshot> jadi = Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots();
    jadi.listen((onData){
      if (!mounted) return;
      if (onData.exists) {
        if (onData.data['jemput_antar']!=null) {
          if (!mounted) return;
          setState(() {
            isSwitched=onData.data['jemput_antar'];
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: .0, bottom: 10.0),
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
                child: Text('Layanan Jemput Antar', style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text('Apakah Galon Anda Mau Dijemput Dan Diantar?', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 11),),
              ),
            ],
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(right:3.0),
            child: Switch(
              value: isSwitched,
              onChanged: (value) async {
                if (!loading) {
                  setState(() {
                    loading=true;
                  });
                  await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
                    'jemput_antar':value,
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
              activeTrackColor: Colors.blue[200],
              activeColor: Colors.blue,
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