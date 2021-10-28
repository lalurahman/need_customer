import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class JaringanCek extends StatefulWidget {
  JaringanCek({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  _JaringanCekState createState() => _JaringanCekState();
}

class _JaringanCekState extends State<JaringanCek> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream:  Connectivity().onConnectivityChanged,
      builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot){
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data==ConnectivityResult.mobile) {
            return widget.child;
          } else if(snapshot.data==ConnectivityResult.none){
            return aktifasiOff('Harap Periksa Jaringan Anda');
          } else if(snapshot.data==ConnectivityResult.wifi){
            return widget.child;
          }
        }
        return kosong();
      },
    );
  }

  Widget aktifasiOff(String title){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.local_airport, size: 70.0,),
          Padding(
            padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
            child: Text('Maaf', style: TextStyle(fontWeight: FontWeight.w600),),
          ),
          Text(title.toString()),
        ],
      ),
    );
  }

  Widget kosong(){
    return Container(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: CompanyColors.utama,);
  }
}