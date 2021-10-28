import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:need_customer/detaildepot/contentdepot/contentdepot.dart';
import 'package:need_customer/detaildepot/headerdepot/headerdepot.dart';
import 'package:need_customer/detaildepot/totransaction/totransaction.dart';
import 'package:need_customer/service/depotcek.dart';
import 'package:need_customer/service/jaringancek.dart';

import 'menudetailgalon/menudetailgalon.dart';

class DetailDepot extends StatefulWidget {
  DetailDepot({Key key, @required this.id, @required this.myPosition, @required this.voucher}) : super(key: key);
  final String id;
  final Position myPosition;
  final String voucher;
  
  @override
  _DetailDepotState createState() => _DetailDepotState();
}

class _DetailDepotState extends State<DetailDepot> {
  @override
  Widget build(BuildContext context) {
    return JaringanCek(
      child: DepotCek(
        idDepot: widget.id,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    HeaderDepot(id: widget.id,),
                    ContentDepot(id: widget.id,),
                    Container(height: 8.0, width: MediaQuery.of(context).size.width, color: Colors.grey[200],),
                    MenuDetailGalon(id: widget.id,),
                    Container(height: 8.0, width: MediaQuery.of(context).size.width, color: Colors.grey[200],),
                    Container(height: 60.0),
                  ],
                ),
              ),
              ToTransaction(idDepot: widget.id, myPosition:widget.myPosition, voucher:widget.voucher)
            ],
          ),
        ),
      ),
    );
  }
}