import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class BgHeaderProfile extends StatefulWidget {
  BgHeaderProfile({Key key}) : super(key: key);

  @override
  _BgHeaderProfileState createState() => _BgHeaderProfileState();
}

class _BgHeaderProfileState extends State<BgHeaderProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 190.0,
      decoration: BoxDecoration(color: CompanyColors.utama),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 190.0,
            child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,)),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 190.0,
            decoration: BoxDecoration(color: CompanyColors.utama.withOpacity(.8)),
          )
        ],
      ),
    );
  }
}