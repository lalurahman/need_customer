import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InvBy extends StatefulWidget {
  InvBy({Key key, @required this.idUser}) : super(key: key);
  final String idUser;
  @override
  _InvByState createState() => _InvByState();
}

class _InvByState extends State<InvBy> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_customer').document(widget.idUser).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            if (snapshot.data.data['inv_by']!=null) {
              // print(snapshot.data.data['inv_by'].toString());
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('data_customer').where('ref_kode', isEqualTo: snapshot.data.data['inv_by'].toString()).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                  if (snapshot2.connectionState==ConnectionState.active) {
                    if (snapshot2.data.documents.length>0) {
                      // print(snapshot2.data.documents.first.data['name'].toString());
                      return wdg(snapshot2.data.documents.first.data['name']);
                    }
                  }
                  return Container();
                }
              );
            }
          }
        }
        return Container();
      }
    );
  }

  Widget wdg(String nama){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45.0,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      decoration: BoxDecoration(color: Colors.purple[300], borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('invited by', style: TextStyle(color: Colors.white, fontSize: 10.0)),
          Text(nama.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}