import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/upgradeform.dart';

class UpgradeAfiliasi extends StatefulWidget {
  UpgradeAfiliasi({Key key, @required this.idUser}) : super(key: key);
  final String idUser;

  @override
  _UpgradeAfiliasiState createState() => _UpgradeAfiliasiState();
}

class _UpgradeAfiliasiState extends State<UpgradeAfiliasi> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot>snapshot) {
        bool statusNs = false;
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            if (snapshot.data.data['status'].toString().toUpperCase()=='SELESAI') {
              statusNs = true;
            }
          }
        }
        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpgradeForm(idUser:widget.idUser)),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            decoration: BoxDecoration(
              color: Colors.orange[500],
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(colors: [
                (statusNs)?Colors.blue[400]:Colors.grey,
                (statusNs)?Colors.orange[400]:Colors.red,
              ]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star, color: Colors.white, size: 16.0,),
                Text((statusNs)?'  UPGRADE DONE':'  UPGRADE TO NS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                // Text('  UPGRADE TO NEM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                // Text('  UPGRADE TO NET', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                Expanded(child: Container()),
                (statusNs)?Container():Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.0,),
              ],
            ),
          ),
        );
      }
    );
  }
}