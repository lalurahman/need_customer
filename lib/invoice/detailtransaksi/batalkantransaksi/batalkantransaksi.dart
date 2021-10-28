import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/invoice/detailtransaksi/batalkantransaksi/alasanpembatalan/alasanpembatalan.dart';

class BtalkanTransaksi extends StatefulWidget {
  BtalkanTransaksi({Key key, @required this.idTransaksi, @required this.dataSn}) : super(key: key);
  final String idTransaksi;
  final DocumentSnapshot dataSn;

  @override
  _BtalkanTransaksiState createState() => _BtalkanTransaksiState();
}

class _BtalkanTransaksiState extends State<BtalkanTransaksi> {
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlasanPembatalan(idTransaksi: widget.idTransaksi,)),
        );
        // if (!loading) {
        //   setState(() {
        //     loading=true;
        //   });
        //   AwesomeDialog(
        //     context: context,
        //     animType: AnimType.SCALE,
        //     dialogType: DialogType.INFO,
        //     dismissOnTouchOutside: false,
        //     tittle: 'Peringatan',
        //     desc:   'Yakin Ingin Membatalkan Transaksi?',
        //     btnOkText: 'Lanjut',
        //     btnCancelText: 'Tidak',
        //     btnCancelOnPress: () {
        //       setState(() {
        //         loading=false;
        //       });
        //     },
        //     btnOkOnPress: () async {
        //       Map<String, dynamic> dataBaru = widget.dataSn.data;
        //       dataBaru['status'] = 'Dibatalkan';
        //       dataBaru['dibatalkan_oleh'] = 'customer';
        //       if(widget.dataSn.data['status_voucher']){
        //         await Firestore.instance.collection('voucher').document(widget.dataSn.data['voucher']).get().then((onValue22) async {
        //           if(onValue22.exists){
        //             await Firestore.instance.collection('voucher').document(widget.dataSn.data['voucher']).updateData({'stok':onValue22.data['stok']+1});
        //             await Firestore.instance.collection('data_customer').document(widget.dataSn.data['id_user']).get().then((onValue24) async {
        //               if (onValue24.exists) {
        //                 await Firestore.instance.collection('data_customer').document(widget.dataSn.data['id_user']).updateData({'point':onValue24.data['point']+onValue22.data['point']});
        //                 dataBaru['voucher'] = '-';
        //                 dataBaru['voucher_lama'] = widget.dataSn.data['voucher'];
        //                 await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).updateData(dataBaru).then((onValue){
        //                   setState(() {
        //                     loading=false;
        //                   });
        //                 });
        //               }
        //             });
        //           }
        //         });
        //       }else{
        //         await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).updateData(dataBaru).then((onValue){
        //           setState(() {
        //             loading=false;
        //           });
        //         });
        //       }
        //     }
        //   ).show();
        // }

      },
      child: Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0), 
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 2.0)
          ]
        ),
        child: Center(child: Text('BATALKAN PESANAN', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w700),)),
      ),
    );
  }
}