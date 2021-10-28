import 'package:flutter/material.dart';

class RekapTransaksiku extends StatefulWidget {
  RekapTransaksiku({Key key, @required this.idUser, @required this.antar, @required this.batalkan,
    @required this.menunggu, @required this.proses, @required this.selesai, @required this.total  
  }) : super(key: key);
  final String idUser;
  final int total;
  final int batalkan;
  final int proses;
  final int selesai;
  final int antar;
  final int menunggu;
  @override
  _RekapTransaksikuState createState() => _RekapTransaksikuState();
}

class _RekapTransaksikuState extends State<RekapTransaksiku> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:15.0, bottom: 10.0),
          child: Text('Rekap Transaksi', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
        ),
        Padding(
          padding: const EdgeInsets.only(left:10.0, right: 10.0),
          child: Row(
            children: <Widget>[
              wdg('Total', widget.total, Colors.grey),
              wdg('Di Batalkan', widget.batalkan, Colors.red[400]),
              wdg('Di Proses', widget.proses, Colors.blue[300]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 10.0),
          child: Row(
            children: <Widget>[
              wdg('Selesai', widget.selesai, Colors.green[300]),
              wdg('Di Antar', widget.antar, Colors.orange[300]),
              wdg('Menunggu', widget.menunggu, Colors.purple[300]),
            ],
          ),
        ),
      ],
    );
  }

  Widget wdg(String title, int total, Color clr){
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          // height: 80.0,
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
            color: clr,
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title.toString(), style: TextStyle(color: Colors.white, fontSize: 12.0),),
              Text('Jumlah Data', style: TextStyle(color: Colors.white, fontSize: 9.0),),
              Padding(
                padding: const EdgeInsets.only(top:5.0, bottom: 5.0),
                child: Text(total.toString(), style: TextStyle(color: Colors.white, fontSize: 23.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}