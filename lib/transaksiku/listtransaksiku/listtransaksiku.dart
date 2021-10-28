import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/invoice/invoice.dart';
import 'package:need_customer/newinvoice/newinvoice.dart';

class ListTransaksiku extends StatefulWidget {
  ListTransaksiku({Key key, @required this.data}) : super(key: key);
  final List<DocumentSnapshot> data;
  @override
  _ListTransaksikuState createState() => _ListTransaksikuState();
}

class _ListTransaksikuState extends State<ListTransaksiku> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return (widget.data.length==0)?Container():Container(
      margin: EdgeInsets.only(top:10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:15.0, bottom: 10.0),
            child: Text('List Transaksi', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
          ),
          Column(
            children: widget.data.map((f){
              return wdg(f);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget wdg(DocumentSnapshot f){
    Color clr = Colors.grey;
    switch (f.data['status']) {
      case 'Menunggu Konfirmasi':
        clr = Colors.purple;
        break;
      case 'Dibatalkan':
        clr = Colors.red;
        break;
      case 'Dalam Proses':
        clr = Colors.blue;
        break;
      case 'Sementara Diantar':
        clr = Colors.orange;
        break;
      case 'Selesai':
        clr = Colors.green;
        break;
      default:
    }
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Invoice(idTransaksi: f.documentID,)),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 2.0)
          ]
        ),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Id Transaksi', style: TextStyle(color: Colors.grey, fontSize: 11.0),),
                Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: Text(f.documentID.toString(), style: TextStyle(color: clr),),
                ),
              ],
            ),
            Expanded(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('status', style: TextStyle(color: Colors.grey, fontSize: 11.0),),
                Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: Text(f.data['status'].toString(), style: TextStyle(color: clr),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  
}