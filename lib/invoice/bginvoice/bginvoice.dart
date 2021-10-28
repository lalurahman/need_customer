import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/chat/chat.dart';
import 'package:need_customer/invoice/bginvoice/trackingkurir/trackingkurir.dart';
import 'package:need_customer/invoice/detailtransaksi/detailtransaksi.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BgInvoice extends StatefulWidget {
  BgInvoice({Key key, @required this.idTransaksi, @required this.dataSn, @required this.title, @required this.imageAss, @required this.clr, @required this.bukaChat, @required this.batalkan, @required this.animasi}) : super(key: key);
  final String idTransaksi;
  final String title;
  final String imageAss;
  final Color clr;
  final DocumentSnapshot dataSn;
  final bool bukaChat;
  final bool batalkan;
  final bool animasi;
  @override
  _BgInvoiceState createState() => _BgInvoiceState();
}

class _BgInvoiceState extends State<BgInvoice> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PanelController pnController;

  int jumlahPesan = 0;
  chatToRead() async {
    Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').where('read', isEqualTo: false).where('dari', isEqualTo: 'mitra').snapshots().listen((onValue) {
      if (onValue.documents.length > 0) {
        if (!mounted) return;
        setState(() {
          jumlahPesan = onValue.documents.length;
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
    if (widget.animasi) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Invoice'),
        backgroundColor: widget.clr,
        actions: <Widget>[
          (!widget.bukaChat) ? Container() : (widget.title=='SEDANG MENCARI KURIR')?Container():Chatnya(dataSn: widget.dataSn, idTransaksi: widget.idTransaksi, jumlahPesan: jumlahPesan,),
        ],
      ),
      body: SlidingUpPanel(
        parallaxEnabled: true,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        controller: pnController,
        renderPanelSheet: false,
        panel: DetailTransaksi(idTransaksi: widget.idTransaksi, dataSn: widget.dataSn, batalkan: widget.batalkan),
        minHeight: 60.0,
        maxHeight: MediaQuery.of(context).size.height - 300.0,
        collapsed: GestureDetector(
          onTap: () {
            pnController.open();
          },
          child: Container(
            margin: EdgeInsets.only(top: 5.0),
            decoration: BoxDecoration(
                color: widget.clr,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 3.0,
                  width: 50.0,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2.0)]),
                ),
                Text(
                  "Lihat Detail Transaksi",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
        body: (widget.title=='SEMENTARA DIANTAR')?TrackingKurir(dataSn: widget.dataSn):wdg(),
      ),
    );
  }

  Widget wdg() {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/pattern.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white.withOpacity(.9),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 130.0),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              (!widget.animasi)
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomPaint(
                            painter: new SpritePainter(_controller, widget.clr.withOpacity(.3)),
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
                    Image.asset(
                      widget.imageAss.toString(),
                      width: (widget.title == 'TRANSAKSI DIBATALKAN') ? MediaQuery.of(context).size.width - 150 : MediaQuery.of(context).size.width - 270,
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
                    Text(
                      'Status Konfirmasi',
                      style: TextStyle(fontSize: 13.0, color: Colors.grey),
                    ),
                    (widget.title != 'TRANSAKSI SELESAI')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 330.0, top: 10.0),
                            child: Text(
                              widget.title,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: widget.clr),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 0.0, top: 10.0),
                            child: Text(
                              widget.title,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: widget.clr),
                            ),
                          ),
                    (widget.title != 'TRANSAKSI SELESAI')
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 330.0, top: 10.0),
                            child: Container(
                                // padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                                // decoration: BoxDecoration(color: Colors.white),
                                child: Text(
                              'Terimakasih Telah Mengorder',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: widget.clr),
                            )),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 300.0, bottom: 10.0),
                      child: Text(
                        'Kode Transaksi',
                        style: TextStyle(fontSize: 13.0, color: Colors.grey),
                      ),
                    ),
                    Text(
                      widget.idTransaksi,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: widget.clr),
                    ),
                    // (widget.title!='MENUNGGU KONFIRMASI DEPOT')?Container():
                    // Container(
                    //   // width: 300.0,
                    //   // height: 30.0,
                    //   child: Center(child: Text('Transaksi akan otomatis dibatalkan : ${(widget.dataSn.data['timeout']!=null)?widget.dataSn.data['timeout'].toString():'0'}', style: TextStyle(fontSize: 13.0, color: Colors.grey),))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;
  final Color colora;
  SpritePainter(this._animation, this.colora) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = colora.withOpacity(opacity);

    double size = rect.width / 1.5;
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

class Chatnya extends StatefulWidget {
  Chatnya({Key key, @required this.idTransaksi, @required this.dataSn, @required this.jumlahPesan}) : super(key: key);
  final String idTransaksi;
  final DocumentSnapshot dataSn;
  final int jumlahPesan;
  @override
  _ChatnyaState createState() => _ChatnyaState();
}

class _ChatnyaState extends State<Chatnya> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Chat(idTransaksi: widget.idTransaksi, idUser: widget.dataSn['id_user'], idCustomer: widget.dataSn['id_depot'])),
            );
          },
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 5.0),
                child: Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
              ),
              (widget.jumlahPesan == 0)
                  ? Container()
                  : Positioned(
                      top: 27.0,
                      left: 0.0,
                      child: Container(
                          decoration: BoxDecoration(color: Colors.red.withOpacity(.8)),
                          padding: EdgeInsets.only(left: 3.0, right: 3.0, top: 3.0, bottom: 3.0),
                          child: Text(
                            widget.jumlahPesan.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 9.0, fontWeight: FontWeight.w700),
                          )),
                    ),
            ],
          )),
    );
  }
}
