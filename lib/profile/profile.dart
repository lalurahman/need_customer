import 'package:flutter/material.dart';
import 'package:need_customer/profile/headerprofile/headerprofile.dart';
import 'package:need_customer/profile/headerprofile/menuprofile/menuprofile.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderProfile(),
            MenuProfile(),
          ],
        ),
      ),
    );
  }

  // TextEditingController txtController;
  // @override
  // void initState() {
  //   super.initState();
  //   txtController=TextEditingController();
  // }
  // @override
  // void dispose() { 
  //   txtController.dispose();
  //   super.dispose();
  // }
  // Widget tbl(){
  //   return Container(
  //     padding: EdgeInsets.only(left: 15.0, right: 15.0),
  //     child: Column(
  //       children: <Widget>[
  //         Text('Masukkan Nomor HP Yang Dapat Dihubungi, Awali Dengan (0)', textAlign: TextAlign.center, style: TextStyle(height: 1.7),),
  //         Text('No Anda Akan Disimpan Kedatabase', textAlign: TextAlign.center, style: TextStyle(height: 1.7, fontSize: 10.0, color: Colors.grey),),
  //         Text('Untuk Transaksi Selanjutnya Anda Tidak Perlu Menginput Nomor Kembali', textAlign: TextAlign.center, style: TextStyle(height: 1.7, fontSize: 10.0, color: Colors.grey),),
  //         TextField(
  //           autofocus: true,
  //           controller: txtController,
  //           keyboardType: TextInputType.number
  //         ),
  //       ],
  //     ),
  //   );
  // }
}