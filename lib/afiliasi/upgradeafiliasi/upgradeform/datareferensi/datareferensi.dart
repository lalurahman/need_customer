import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:need_customer/afiliasi/upgradeafiliasi/upgradeform/datadiri/btnlanjutdatadiri/btnlanjutdatadiri.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:need_customer/custom/customform.dart';
import 'package:need_customer/custom/uploadimagecustom.dart';
import 'package:need_customer/theme/companycolors.dart';
// import 'package:need_mitra/custom/customform.dart';
// import 'package:need_mitra/custom/uploadimagecustom.dart';
// import 'package:need_mitra/uploadktp/btnlanjutktp/btnlanjutktp.dart';

class DataReferensi extends StatefulWidget {
  DataReferensi({Key key}) : super(key: key);

  @override
  _DataReferensiState createState() => _DataReferensiState();
}

class _DataReferensiState extends State<DataReferensi> {
  TextEditingController ctrKodeReferensi=TextEditingController();
  TextEditingController ctrNama=TextEditingController();
  TextEditingController ctrAlamat=TextEditingController();
  String strKodeReferensi,strNama,strAlamat,idUser,urlImage;
  bool stsData=false;

  getUser() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      await FirebaseAuth.instance.currentUser().then((onValue4) async {
        setState(() {
          idUser=onValue4.uid;
        });
        // await Firestore.instance.collection('data_ktp_afiliasi').document(onValue4.uid).get().then((onValue){
        //   if (onValue.exists) {
        //     setState(() {
        //       strKodeReferensi=onValue.data['nik'];
        //       strNama=onValue.data['nama'];
        //       strAlamat=onValue.data['alamat'];

        //       ctrKodeReferensi..text=onValue.data['nik'].toString();
        //       ctrNama..text=onValue.data['nama'].toString();
        //       ctrAlamat..text=onValue.data['alamat'].toString();

        //       urlImage=onValue.data['foto_ktp'].toString();
        //       stsData=true;
        //     });
        //   }
        // });
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    super.dispose();
    ctrKodeReferensi.dispose();
    ctrNama.dispose();
    ctrAlamat.dispose();
  }

  File _image;

  Future getImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.collections),
                title: new Text('Galeri'),
                onTap: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (image!=null) {
                    setState(() {
                      _image = image;
                      urlImage=null;
                      ctrKodeReferensi..text=strKodeReferensi;
                      ctrNama..text=strNama;
                      ctrAlamat..text=strAlamat;
                    });
                  }
                  Navigator.pop(context);
                }
              ),
              new ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text('Foto'),
                onTap: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                  if (image!=null) {
                    setState(() {
                      _image = image;
                      urlImage=null;
                      ctrKodeReferensi..text=strKodeReferensi;
                      ctrNama..text=strNama;
                      ctrAlamat..text=strAlamat;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kode Referensi'),
        backgroundColor: CompanyColors.utama,
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // UploadImageCustom(title: 'Upload KTP', subtitle: 'Upload KTP anda',
              //   image: _image, imageGet: getImage, urlImage:urlImage,
              // ),
              CustomForm(title: 'Kode Referensi', subtitle: 'Masukkan Kode Referensi', ctr: ctrKodeReferensi, maxLength: 17,
                onChange: (value){
                  setState(()=>strKodeReferensi=value);
                },
              ),
              Text('Nama'),
              Text('Nama Pengguna', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('data_customer').where('ref_kode', isEqualTo: strKodeReferensi.toString()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  String namaPengguna = '-';
                  int datanya = 0;
                  if (snapshot.connectionState==ConnectionState.active) {
                    if (snapshot.data.documents.length>0) {
                      namaPengguna = snapshot.data.documents.first.data['name'];
                      datanya = snapshot.data.documents.length;
                    }
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(color: (datanya>0)?Colors.orange:Colors.red, borderRadius: BorderRadius.circular(5.0)),
                        child: Center(child: Text(namaPengguna.toString(), style: TextStyle(color: Colors.white, fontSize: 16.0), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                      Divider(),
                      (datanya<=0)?Container():
                      GestureDetector(
                        onTap: (){
                          if(datanya>0){
                            Navigator.pop(context, strKodeReferensi.toString());
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
                          child: Center(child: Text('GUNAKAN KODE', style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}