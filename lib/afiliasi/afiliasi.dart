import 'package:flutter/material.dart';
import 'package:need_customer/afiliasi/akun/akun.dart';
import 'package:need_customer/afiliasi/beritaafiliasi/beritaafiliasi.dart';
import 'package:need_customer/afiliasi/invby/invby.dart';
import 'package:need_customer/afiliasi/myteam/myteam.dart';
import 'package:need_customer/afiliasi/pencapaian/pencapaian.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeafiliasi.dart';
import 'package:need_customer/newhome/berita/berita.dart';
import 'package:need_customer/theme/companycolors.dart';
//import Arduino('text'),

class Afiliasi extends StatefulWidget {
  Afiliasi({Key key, @required this.idUser}) : super(key: key);
  final String idUser;
  @override
  _AfiliasiState createState() => _AfiliasiState();
}

class _AfiliasiState extends State<Afiliasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Program Afiliasi'),
        backgroundColor: CompanyColors.utama,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Akun(idUser: widget.idUser,),
            UpgradeAfiliasi(idUser: widget.idUser),
            Pencapaian(idUser: widget.idUser,),
            InvBy(idUser: widget.idUser),
            MyTeam(idUser: widget.idUser),
            BeritaAfiliasi(),
            Container(height: 0.0,),
          ],
        ),
      ),
    );
  }
}