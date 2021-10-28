import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class DetailMyteam extends StatefulWidget {
  DetailMyteam({Key key, @required this.idUser}) : super(key: key);
  final String idUser;

  @override
  _DetailMyteamState createState() => _DetailMyteamState();
}

class _DetailMyteamState extends State<DetailMyteam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('My Team'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
              wdg(),
            ],
          ),
        ),
      )
    );
  }

  Widget wdg(){
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('dary kusuma ', style: TextStyle(color: Colors.grey),),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text('darykusuma31012003@gmail.com'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}