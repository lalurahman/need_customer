import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/chat/chat.dart';
import 'package:need_customer/invoice/detailtransaksi/detailtransaksi.dart';
import 'package:need_customer/theme/companycolors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MenungguKonfirmasi extends StatefulWidget {
  MenungguKonfirmasi({Key key, @required this.idTransaksi, @required this.dataSn}) : super(key: key);
  final String idTransaksi;
  final DocumentSnapshot dataSn;
  @override
  _MenungguKonfirmasiState createState() => _MenungguKonfirmasiState();
}

class _MenungguKonfirmasiState extends State<MenungguKonfirmasi> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PanelController pnController;
  
  int jumlahPesan = 0; 
  chatToRead() async {
    Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').where('read', isEqualTo: false).where('dari', isEqualTo: 'mitra').snapshots().listen((onValue) {
      if (onValue.documents.length>0) {
        if (!mounted) return;
        setState(() {
          jumlahPesan=onValue.documents.length;
        });
      }
    });
  }

  @override
  void initState() {
    chatToRead();
    super.initState();
    _controller = new AnimationController(
      vsync: this,
    );
    pnController = PanelController();
    // _startAnimation();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _startAnimation() {
  //   _controller.stop();
  //   _controller.reset();
  //   _controller.repeat(
  //     period: Duration(seconds: 1),
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(title: const Text('Invoice'),
        backgroundColor: CompanyColors.utama,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat(idTransaksi:widget.idTransaksi, idUser: widget.dataSn['id_user'], idCustomer:widget.dataSn['id_depot'])),
                );
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0, right: 5.0),
                    child: Icon(Icons.chat, color: Colors.white,),
                  ),
                  (jumlahPesan==0)?Container():
                  Positioned(
                    top: 27.0,
                    left: 0.0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.red.withOpacity(.8)),
                      padding: EdgeInsets.only(left: 3.0, right: 3.0, top: 3.0, bottom: 3.0),
                      child: Text(jumlahPesan.toString(), style: TextStyle(color: Colors.white, fontSize: 9.0, fontWeight: FontWeight.w700),)),
                  ),
                ],
              )),
          )
        ],
      ),
      body: SlidingUpPanel(
        parallaxEnabled: true,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        controller: pnController,
        renderPanelSheet: false,
        panel: DetailTransaksi(idTransaksi: widget.idTransaksi, dataSn: widget.dataSn, batalkan:true),
        minHeight: 60.0,
        maxHeight: MediaQuery.of(context).size.height-300.0,
        collapsed: GestureDetector(
          onTap: (){
            pnController.open();
          },
          child: Container(
            margin: EdgeInsets.only(top:5.0),
            decoration: BoxDecoration(
              color: CompanyColors.utama,
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 5.0)
              ],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0),)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 3.0, width: 50.0,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 2.0)
                    ]
                  ),
                ),
                Text("Lihat Detail Transaksi",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)
              ],
            ),
          ),
        ),
        body: wdg(),
      ),
    );
  }

  Widget wdg(){
    return Container(
      padding: EdgeInsets.only(bottom:130.0),
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomPaint(
                  painter: new SpritePainter(_controller),
                  child: new SizedBox(
                    width: 250.0,
                    height: 250.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.assignment, color: Colors.white, size: 55.0,)
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Status Konfirmasi', style: TextStyle(fontSize: 13.0, color: Colors.grey),),
                Padding(
                  padding: const EdgeInsets.only(bottom:330.0, top: 10.0),
                  child: Text('MENUNGGU KONFIRMASI DEPOT', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: CompanyColors.utama),),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:300.0, bottom: 10.0),
                  child: Text('Kode Transaksi', style: TextStyle(fontSize: 13.0, color: Colors.grey),),
                ),
                Text(widget.idTransaksi, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: CompanyColors.utama),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;

  SpritePainter(this._animation) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = CompanyColors.utama.withOpacity(opacity);

    double size = rect.width / 2;
    double area = size * size;
    double radius = sqrt(area * value / 4);

    final Paint paint = new Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}