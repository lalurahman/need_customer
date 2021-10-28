import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class AlasanPembatalan extends StatefulWidget {
  AlasanPembatalan({Key key, @required this.idTransaksi,}) : super(key: key);
  final String idTransaksi;

  @override
  _AlasanPembatalanState createState() => _AlasanPembatalanState();
}

class _AlasanPembatalanState extends State<AlasanPembatalan> {
  bool loading = false;
  @override
  void setState(fn) {
    loading = false;
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alasan Pembatalan'),
        backgroundColor: CompanyColors.utama,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).snapshots() ,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot2){
            if (snapshot2.connectionState==ConnectionState.active) {
              if (snapshot2.data.exists) {
                if (snapshot2.data.data['status']=='Menunggu Konfirmasi'||snapshot2.data.data['status']=='Dalam Proses') {
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('ketentuan').document('alasan_pembatalan').collection('detail').snapshots() ,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.connectionState==ConnectionState.active) {
                        if (snapshot.data.documents.length>0) {
                          return Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Column(
                              children: snapshot.data.documents.map((f){
                                return wdg(f['value'], snapshot2.data);
                              }).toList(),
                            ),
                          );
                        }
                      }
                      return Container();
                    },
                  );
                }
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget wdg(String alasan, DocumentSnapshot dataSn){
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            if (!loading) {
              setState(() {
                loading=true;
              });
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                dialogType: DialogType.INFO,
                dismissOnTouchOutside: false,
                tittle: 'Peringatan',
                desc:   'Yakin Ingin Membatalkan Transaksi?',
                btnOkText: 'Lanjut',
                btnCancelText: 'Tidak',
                btnCancelOnPress: () {
                  setState(() {
                    loading=false;
                  });
                },
                btnOkOnPress: () async {
                  Map<String, dynamic> dataBaru = dataSn.data;
                  dataBaru['status'] = 'Dibatalkan';
                  dataBaru['dibatalkan_oleh'] = 'customer';
                  if(dataSn.data['status_voucher']){
                    await Firestore.instance.collection('voucher').document(dataSn.data['voucher']).get().then((onValue22) async {
                      if(onValue22.exists){
                        await Firestore.instance.collection('voucher').document(dataSn.data['voucher']).updateData({'stok':onValue22.data['stok']+1});
                        await Firestore.instance.collection('data_customer').document(dataSn.data['id_user']).get().then((onValue24) async {
                          if (onValue24.exists) {
                            await Firestore.instance.collection('data_customer').document(dataSn.data['id_user']).updateData({'point':onValue24.data['point']+onValue22.data['point']});
                            dataBaru['voucher'] = '-';
                            dataBaru['voucher_lama'] = dataSn.data['voucher'];
                            dataBaru['alasan_batal'] = alasan;
                            await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).updateData(dataBaru).then((onValue){
                              setState(() {
                                loading=false;
                              });
                              Navigator.pop(context);
                            });
                          }
                        });
                      }
                    });
                  }else{
                    dataBaru['alasan_batal'] = alasan;
                    await Firestore.instance.collection('final_transaksi').document(widget.idTransaksi).updateData(dataBaru).then((onValue){
                      setState(() {
                        loading=false;
                      });
                      Navigator.pop(context);
                    });
                  }
                }
              ).show();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.blue.withOpacity(0.0),
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Text(alasan, style: TextStyle(fontSize: 17.0),),
          ),
        ),
        Divider(color: Colors.black38,),
      ],
    );
  }
}