import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/invoice/bginvoice/bginvoice.dart';
import 'package:need_customer/service/logincek.dart';
import 'package:need_customer/theme/companycolors.dart';

class Invoice extends StatefulWidget {
  Invoice({Key key, @required this.idTransaksi}) : super(key: key);
  final String idTransaksi;
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    return LoginCek(fcLogin: (AsyncSnapshot<FirebaseUser> dataLogin, AsyncSnapshot<DocumentSnapshot> dataUser) {
      if (dataLogin != null && dataUser != null) {
        return wdg(dataUser.data.documentID, dataUser);
      }
      return Scaffold();
    });
  }

  wdg(String idUser, AsyncSnapshot<DocumentSnapshot> dataUser) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        String stsTransaksi = '';
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.exists) {
            stsTransaksi = snapshot.data.data['status'];
            DocumentSnapshot dataSn = snapshot.data;
            switch (stsTransaksi) {
              case 'Menunggu Konfirmasi':
                return BgInvoice(
                  idTransaksi: widget.idTransaksi,
                  dataSn: dataSn,
                  title: 'SEDANG MENCARI KURIR',
                  imageAss: 'assets/images/notifications.png',
                  clr: CompanyColors.utama,
                  bukaChat: true,
                  batalkan: true,
                  animasi: true,
                );
                // return MenungguKonfirmasi(idTransaksi: widget.idTransaksi, dataSn:dataSn);
                break;
              case 'Dibatalkan':
                return BgInvoice(
                  idTransaksi: widget.idTransaksi,
                  dataSn: dataSn,
                  title: 'TRANSAKSI DIBATALKAN',
                  imageAss: 'assets/images/batalkan2.png',
                  clr: Colors.red,
                  bukaChat: false,
                  batalkan: false,
                  animasi: false,
                );
                // return DiBatalkan(idTransaksi: widget.idTransaksi, dataSn:dataSn);
                break;
              case 'Dalam Proses':
                return BgInvoice(
                  idTransaksi: widget.idTransaksi,
                  dataSn: dataSn,
                  title: 'SEDANG DALAM PROSES',
                  imageAss: 'assets/images/note_taking.png',
                  clr: CompanyColors.utama,
                  bukaChat: true,
                  batalkan: false,
                  animasi: true,
                );
                // return DalamProses(idTransaksi: widget.idTransaksi, dataSn:dataSn);
                break;
              case 'Sementara Diantar':
                return BgInvoice(
                  idTransaksi: widget.idTransaksi,
                  dataSn: dataSn,
                  title: 'SEMENTARA DIANTAR',
                  imageAss: 'assets/images/pengantaran.png',
                  clr: CompanyColors.utama,
                  bukaChat: true,
                  batalkan: false,
                  animasi: true,
                );
                // return SementaraDiantar(idTransaksi: widget.idTransaksi, dataSn:dataSn);
                break;
              case 'Selesai':
                return BgInvoice(
                  idTransaksi: widget.idTransaksi,
                  dataSn: dataSn,
                  title: 'TRANSAKSI SELESAI',
                  imageAss: 'assets/images/order_confirmed.png',
                  clr: CompanyColors.utama,
                  bukaChat: false,
                  batalkan: false,
                  animasi: false,
                );
                // return Selesai(idTransaksi: widget.idTransaksi, dataSn:dataSn);
                break;
              default:
            }
          }
        }
        return Scaffold(
            appBar: AppBar(
              backgroundColor: CompanyColors.utama,
              title: Text('Invoice'),
              actions: <Widget>[],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'status',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    stsTransaksi.toString(),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateChatToRead();
  }

  int jumlahPesan = 0;
  updateChatToRead() async {
    Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').where('read', isEqualTo: false).where('dari', isEqualTo: 'mitra').snapshots().listen((onValue) {
      if (onValue.documents.length > 0) {
        onValue.documents.forEach((f) async {
          if (!mounted) return;
          setState(() {
            jumlahPesan++;
          });
          // await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).collection('list_chat').document(f.documentID).updateData({
          //   'updated_at':DateTime.now(),
          //   'read':true,
          // });
        });
      }
    });
  }
}
