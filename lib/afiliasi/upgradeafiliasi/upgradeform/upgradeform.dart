import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/datadiri/datadiri.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/datareferensi/datareferensi.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/listproduk/listproduk.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/statusupgrade/statusupgrade.dart';
import 'package:need_customer/theme/companycolors.dart';

class UpgradeForm extends StatefulWidget {
  UpgradeForm({Key key, @required this.idUser}) : super(key: key);
  final String idUser;

  @override
  _UpgradeFormState createState() => _UpgradeFormState();
}

class _UpgradeFormState extends State<UpgradeForm> {
  DocumentSnapshot snState;
  String kodeReferensi;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Upgrade Akun'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).snapshots() ,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.connectionState==ConnectionState.active) {
            if (snapshot.data.exists) {
              return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('data_customer').document(widget.idUser).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot2) {
                  String nama = '-';
                  if (snapshot2.connectionState==ConnectionState.active) {
                    if (snapshot2.data.exists) {
                      nama = snapshot2.data.data['name'];
                    }
                  }
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).collection('databarang').snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                      int harga = 0;
                      String deskripsi = '-';
                      String namaProduk = '-';
                      String urlImage;
                      if (snapshot3.connectionState==ConnectionState.active) {
                        if (snapshot3.data.documents.length>0) {
                          harga = snapshot3.data.documents.first.data['harga'];
                          deskripsi = snapshot3.data.documents.first.data['deskripsi'];
                          namaProduk = snapshot3.data.documents.first.data['nama'];
                          urlImage = snapshot3.data.documents.first.data['url_image'];
                        }
                      }
                      return StatusUpgrade(nama: nama.toString(), url: urlImage, deskripsi: deskripsi.toString(),
                        harga: harga, namaProduk: namaProduk.toString(), status: snapshot.data.data['status'].toString().toUpperCase(), idUser: widget.idUser,
                      );
                    }
                  );
                }
              );
            }else{
              return dataKosong();
            }
          }
          return Container();
        },
      ),
    );
  }

  dataKosong(){
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Upgrade Akun', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Text('Upgrade Akun Anda Sekarang', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Text('Harap mengisi NO HP dengan benar', style: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w400),),
          ),
          GestureDetector(
            onTap: () async {
              DocumentSnapshot data = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListProduk(idUser:widget.idUser)),
              );
              if (data!=null) {
                setState(() {
                  snState = data;
                });
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(color: (snState!=null)?CompanyColors.utama:Colors.grey, borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  (snState!=null)?Icon(Icons.assignment_turned_in, color: Colors.white,):Container(),
                  Text('  Pilih Produk Belanja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15.0,)
                ],
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('data_ktp_afiliasi').document(widget.idUser).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              bool aktif = false;
              if (snapshot.connectionState==ConnectionState.active) {
                if (snapshot.data.exists) {
                  aktif = true;
                }
              }
              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataDiri()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(color: (aktif)?CompanyColors.utama:Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      (aktif)?Icon(Icons.assignment_turned_in, color: Colors.white,):Container(),
                      Text('  Masukkan Data Diri', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                      Expanded(child: Container()),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15.0,)
                    ],
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              String data = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataReferensi()),
              );
              if (data!=null) {
                setState(() {
                  kodeReferensi = data;
                });
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(color: (kodeReferensi!=null)?CompanyColors.utama:Colors.grey, borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  (kodeReferensi!=null)?Icon(Icons.assignment_turned_in, color: Colors.white,):Container(),
                  Text((kodeReferensi!=null)?'  KODE : ${kodeReferensi.toString()}':'  Masukkan Kode Referensi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15.0,)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              String data = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataReferensi()),
              );
              if (data!=null) {
                setState(() {
                  kodeReferensi = data;
                });
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(color: (kodeReferensi!=null)?CompanyColors.utama:Colors.grey, borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  // (kodeReferensi!=null)?Icon(Icons.assignment_turned_in, color: Colors.white,):Container(),
                  Text('No Rekening', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15.0,)
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () async {
              if(snState!=null){
                await Firestore.instance.collection('data_ktp_afiliasi').document(widget.idUser).get().then((onValue){
                  if (onValue.exists) {
                    if (kodeReferensi!=null) {
                      print(snState.data);
                      AwesomeDialog(context: context,
                        dialogType: DialogType.INFO,
                        animType: AnimType.BOTTOMSLIDE,
                        tittle: 'Info',
                        desc: 'Yakin Ingin Melanjutkan?',
                        btnOkText: 'LANJUT',
                        btnOkOnPress: () async {
                          await Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).setData({
                            'ref_kode':kodeReferensi.toString().toUpperCase(),
                            'status':'Menunggu Konfirmasi',
                            'created_at':DateTime.now(),
                            'updated_at':DateTime.now(),
                          });
                          await Firestore.instance.collection('konfirmasi_ns').document(widget.idUser).collection('databarang').document(snState.documentID).setData(snState.data);

                        },
                        btnCancelText: 'BATAL',
                        btnCancelOnPress: () {},
                      ).show();
                    }else{
                      peringatan('Harap mengisi kode referensi');
                    }
                  }else{
                    peringatan('Harap mengisi data diri');
                  }
                });
              }else{
                peringatan('Harap memilih produk');
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  // ns
                  // nem
                  // net
                  // Icon(Icons.assignment_turned_in, color: Colors.white,):Container(),
                  Text('  LANJUT UPGRADE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15.0,)
                ],
              ),
            ),
          ),
          // TextFormField(
          //   decoration: const InputDecoration(
          //     icon: Icon(Icons.person),
          //     hintText: 'What do people call you?',
          //     labelText: 'Nama',
          //   ),
          //   onSaved: (String value) {
          //     // This optional block of code can be used to run
          //     // code when the user saves the form.
          //   },
          //   validator: (String value) {
          //     return value.contains('@') ? 'Do not use the @ char.' : null;
          //   },
          // )
        ],
      ),
    );
  }

  peringatan(String title){
    AwesomeDialog(context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      tittle: 'Peringatan',
      desc: title,
      btnCancelText: 'OKE',
      btnCancelOnPress: () {},
    ).show();
  }
}