import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingWdg extends StatefulWidget {
  FirebaseMessagingWdg({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  _FirebaseMessagingWdgState createState() => _FirebaseMessagingWdgState();
}

class _FirebaseMessagingWdgState extends State<FirebaseMessagingWdg> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;
  _getToken() async {
    await _firebaseMessaging.getToken().then((deviceToken) async {
      print('Device Token : ${deviceToken.toString()}');
      await Firestore.instance.collection('notif_customer_public').document(deviceToken.toString()).get().then((fsNotif) async {
        if (fsNotif.exists) {
          print('sudah ada');
          await Firestore.instance.collection('notif_customer_public').document(deviceToken.toString()).updateData({
            'updated_at':DateTime.now(),
          });
        }else{
          print('belum ada');
          await Firestore.instance.collection('notif_customer_public').document(deviceToken.toString()).setData({
            'created_at':DateTime.now(),
            'updated_at':DateTime.now(),
          });
        }
      });
      await FirebaseAuth.instance.currentUser().then((fUser) async {
        if (fUser!=null) {
          await Firestore.instance.collection('notif_customer').document(fUser.uid).collection('list_token').document(deviceToken.toString()).get().then((fsNotif) async {
            if (fsNotif.exists) {
              print('sudah ada');
              await Firestore.instance.collection('notif_customer').document(fUser.uid).collection('list_token').document(deviceToken.toString()).updateData({
                'updated_at':DateTime.now(),
              });
            }else{
              print('belum ada');
              await Firestore.instance.collection('notif_customer').document(fUser.uid).collection('list_token').document(deviceToken.toString()).setData({
                'created_at':DateTime.now(),
                'updated_at':DateTime.now(),
              });
            }
          });
        }
      });
    });
  }

  _configureFirebaseListener() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage : $message'); 
        switch (message['data']['status']) {
          // case 'Order Baru':
          //   AwesomeDialog(context: context,
          //     dialogType: DialogType.INFO,
          //     animType: AnimType.BOTTOMSLIDE,
          //     tittle: 'Peringatan',
          //     desc: 'Ada Orderan Masuk',
          //     btnCancelText: 'TUTUP',
          //     btnCancelOnPress: () {
          //     },
          //     btnOkText: 'BUKA',
          //     btnOkOnPress: () async {
          //       await FirebaseAuth.instance.currentUser().then((fUser) async {
          //         if (fUser.uid!=null) {
          //           // Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(builder: (context) => DetailTransaksi(idTransaksi:message['data']['id_order'].toString(), idUser:fUser.uid)),
          //           // );
          //         }
          //       });
          //     }
          //   ).show();
          //   break;
          // default:
        }
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume : $message');
        switch (message['data']['status']) {
          // case 'Order Baru':
          //   await FirebaseAuth.instance.currentUser().then((fUser) async {
          //     if (fUser.uid!=null) {
          //       // Navigator.push(
          //       //   context,
          //       //   MaterialPageRoute(builder: (context) => DetailTransaksi(idTransaksi:message['data']['id_order'].toString(), idUser:fUser.uid)),
          //       // );
          //     }
          //   });
          //   break;
          case 'Pesan Masuk':
            await FirebaseAuth.instance.currentUser().then((fUser) async {
              if (fUser.uid!=null) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DetailTransaksi(idTransaksi:message['data']['id_order'].toString(), idUser:fUser.uid)),
                // );
              }
            });
            break;
          default:
        }
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch : $message');
        _setMessage(message);
      },
    );
  }

  _setMessage(Map<String, dynamic> message){
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    
    setState(() {
      Message m = Message(title, body, mMessage);
      _messages.add(m);
    });
  }

  @override
  void initState() { 
    super.initState();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListener();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: widget.child,
    );
  }
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message){
    this.title = title;
    this.body = body;
    this.message = message;
  }
}