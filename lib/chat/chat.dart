import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:need_customer/chat/inputtext/inputtext.dart';
import 'package:need_customer/theme/companycolors.dart';

class Chat extends StatefulWidget {
  Chat({Key key, @required this.idTransaksi, @required this.idUser, @required this.idCustomer}) : super(key: key);
  final String idTransaksi;
  final String idUser, idCustomer;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _textEditingController = TextEditingController();
  String namadepot = '';

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    // updateChatToRead().cancel();
    if (updateChatToRead2 != null) updateChatToRead2.cancel();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      updateChatToRead2 = updateChatToRead();
      updateChatToRead2.resume();
    });
    getDetailDepot();
  }

  StreamSubscription<QuerySnapshot> updateChatToRead2;

  StreamSubscription<QuerySnapshot> updateChatToRead() {
    return Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').where('read', isEqualTo: false).where('dari', isEqualTo: 'mitra').snapshots().listen((onValue) async {
      if (onValue.documents.length > 0) {
        onValue.documents.forEach((f) async {
          await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').document(f.documentID).updateData({
            'updated_at': DateTime.now(),
            'read': true,
          });
        });
      }
    });
  }

  getDetailDepot() async {
    await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).get().then((onValue1) async {
      if (onValue1.exists) {
        await Firestore.instance.collection('data_mitra').document(onValue1.data['id_depot']).get().then((onValue) {
          if (onValue.exists) {
            setState(() {
              namadepot = onValue.data['nama_depot'];
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Chat - KURIR'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/pattern.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: CompanyColors.utama.withOpacity(.95),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(bottom: 60.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').orderBy('created_at', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                List<Widget> data = [];
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data.documents.length > 0) {
                    data = snapshot.data.documents.map((f) {
                      // Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').document(f.documentID).updateData({
                      //   'updated_at':DateTime.now(),
                      //   'read':true,
                      // });
                      return ctWidget((f.data['dari'] != 'mitra') ? true : false, f.data['pesan'], f.data['read']);
                    }).toList();
                  }
                }
                return ListView(
                  reverse: true,
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  children: data,
                );
              },
            ),
          ),
          InputText(idTransaksi: widget.idTransaksi, idUser: widget.idUser, idCustomer: widget.idCustomer),
        ],
      ),
    );
  }

  Widget ctWidget(bool mitra, String pesan, bool read) {
    return Row(
      children: <Widget>[
        (mitra) ? Expanded(child: Container()) : Container(),
        Container(
          width: MediaQuery.of(context).size.width - 100.0,
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
          decoration: BoxDecoration(color: (mitra) ? Colors.white : Colors.white, borderRadius: BorderRadius.circular(10.0), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2.0)]),
          child: Column(
            crossAxisAlignment: (mitra) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: (mitra) ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: (mitra) ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: <Widget>[
                      (mitra)
                          ? Text(
                              (read) ? 'Sudah Dibaca -' : 'Belum Dibaca -',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10.0, color: (read) ? Colors.green : Colors.red),
                            )
                          : Container(),
                      Text(
                        (mitra) ? ' Customer' : 'Kurir',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.0),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Text(pesan.toString(), style: TextStyle(fontSize: 14.0), textAlign: (mitra) ? TextAlign.right : TextAlign.left),
            ],
          ),
        )
      ],
    );
  }
}
