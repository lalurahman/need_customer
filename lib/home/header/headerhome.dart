import 'package:flutter/material.dart';
import 'package:need_customer/home/header/wallet/wallet.dart';
import 'package:need_customer/theme/companycolors.dart';

class HeaderHome extends StatefulWidget {
  HeaderHome({Key key}) : super(key: key);

  @override
  _HeaderHomeState createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80.0,
          color: CompanyColors.utama,
        ),
        SafeArea(
          child: Container(
            // decoration: BoxDecoration(color: Colors.red),
            height: 115.0,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: CompanyColors.utama),
                  height: 67.0,
                ),
                Wallet(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
