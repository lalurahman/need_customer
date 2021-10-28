import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/invoice/detailtransaksi/detailtransaksi.dart';
import 'package:need_customer/theme/companycolors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Selesai extends StatefulWidget {
  Selesai({Key key, @required this.idTransaksi, @required this.dataSn}) : super(key: key);
  final String idTransaksi;
  final DocumentSnapshot dataSn;
  @override
  _SelesaiState createState() => _SelesaiState();
}

class _SelesaiState extends State<Selesai> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PanelController pnController;
  @override
  void initState() {
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
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(title: const Text('Invoice'),
        backgroundColor: CompanyColors.utama,
      ),
      body: SlidingUpPanel(
        parallaxEnabled: true,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        controller: pnController,
        renderPanelSheet: false,
        panel: DetailTransaksi(idTransaksi: widget.idTransaksi, dataSn: widget.dataSn, batalkan:false),
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
                Text("Lihat Detail Transaksi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)
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
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       CustomPaint(
          //         painter: new SpritePainter(_controller),
          //         child: new SizedBox(
          //           width: 250.0,
          //           height: 250.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 70.0, right: 70.0),
            child: Center(
              child: Container(
                height: 250.0,
                child: Image.asset('assets/images/telahselesai.png'),
              ),
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
                  padding: const EdgeInsets.only(top:10.0),
                  child: Text('TRANSAKSI SELESAI,', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: CompanyColors.utama)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:330.0, top: 10.0),
                  child: Text('TERIMAKASIH SUDAH ORDER DI NEED', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: CompanyColors.utama),),
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