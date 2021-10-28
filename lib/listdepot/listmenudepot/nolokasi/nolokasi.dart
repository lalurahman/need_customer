import 'package:flutter/material.dart';

class NoLokasi extends StatefulWidget {
  NoLokasi({Key key}) : super(key: key);

  @override
  _NoLokasiState createState() => _NoLokasiState();
}

class _NoLokasiState extends State<NoLokasi> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white.withOpacity(.9),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Peringatan,', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.blue[900]),),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Text('Kami tidak dapat Mengakses Lokasi Kamu', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.blue[900])),
              ),
            ],
          ),
        ),
      ],
    );
  }
}