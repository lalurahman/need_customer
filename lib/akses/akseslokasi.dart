import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class AksesLokasi extends StatefulWidget {
  AksesLokasi({Key key, @required this.fc}) : super(key: key);
  final Function fc;
  @override
  _AksesLokasiState createState() => _AksesLokasiState();
}

class _AksesLokasiState extends State<AksesLokasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CompanyColors.utama,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.gps_fixed, size: 40.0, color: Colors.grey[800]),
            Padding(
              padding: const EdgeInsets.only(top:15.0, bottom: 15.0),
              child: Text('Akses lokasi', style: TextStyle(fontSize: 20.0, color: Colors.grey[800]),),
            ),
            Text('Biarkan Kami Mengakses Lokasi Anda', style: TextStyle(fontSize: 12.0, color: Colors.grey[800]),),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text('Guna Mengetahui Lokasi Depot', style: TextStyle(fontSize: 12.0, color: Colors.grey[800]),),
            ),
            Text('Terdekat dari Lokasi Anda', style: TextStyle(fontSize: 12.0, color: Colors.grey[800]),),
            GestureDetector(
              onTap: widget.fc,
              child: Container(
                width: 150.0,
                height: 30.0,
                margin: EdgeInsets.only(top: 15.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 1.0)
                  ]
                ),
                child: Center(
                  child: Text('Izinkan', style: TextStyle(fontSize: 13.0, color: Colors.grey[800], fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}