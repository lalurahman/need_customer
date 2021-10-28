import 'package:flutter/material.dart';
import 'package:need_customer/newhome/header/contentheader/contentheader.dart';
import 'package:need_customer/newhome/header/walletheader/walletheader.dart';
import 'package:need_customer/theme/companycolors.dart';

class Header extends StatefulWidget {
  Header({Key key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.0,
      // color: Colors.green,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 285.0,
            child:Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,), 
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 285.0,
            color: CompanyColors.utama.withOpacity(.1),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              wdg(),
              ContentHeader(),
            ],
          ),
          WalletHeader(),
        ],
      ),
    );
  }

  Widget wdg(){
    return Container(
      padding: EdgeInsets.only(top: 40.0, left: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: CompanyColors.utama
      ),
      child: Row(
        children: <Widget>[
          Image.asset('assets/logo/logo2.png', width: 15.0,),
          Text('  need', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17.0),),
          Text('Aja', style: TextStyle(color: Colors.yellow[300], fontWeight: FontWeight.w600, fontSize: 17.0),),
        ],
      ),
    );
  }
}