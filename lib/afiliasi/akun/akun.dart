import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class Akun extends StatefulWidget {
  Akun({Key key, @required this.idUser}) : super(key: key);
  final String idUser;
  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      // height: 100.0,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Need Store', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
              Row(
                children: <Widget>[
                  Text('Aplikasi berbasis affiliate by ', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),),
                  Text('NEEDAJA', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: CompanyColors.utama),),
                ],
              ),
            ],
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: (){
              
            },
            child: Column(
              children: <Widget>[
                Container(
                  width: 30.0,
                  height: 30.0,
                  margin: EdgeInsets.only(bottom:5.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0), color: Colors.blue[100]),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance.collection('data_customer').document(widget.idUser).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                      if (snapshot.connectionState==ConnectionState.active) {
                        if (snapshot.data.exists) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(snapshot.data.data['url_photo']),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ),
                Text('Akun', style: TextStyle(color: Colors.grey[700], fontSize: 12.0),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}