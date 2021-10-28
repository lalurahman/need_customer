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

class DataDiri extends StatefulWidget {
  DataDiri({Key key}) : super(key: key);

  @override
  _DataDiriState createState() => _DataDiriState();
}

class _DataDiriState extends State<DataDiri> {
  TextEditingController ctrNik=TextEditingController();
  TextEditingController ctrNama=TextEditingController();
  TextEditingController ctrAlamat=TextEditingController();
  TextEditingController ctrNoHp=TextEditingController();
  String strNik,strNama,strAlamat,strNoHp,idUser,urlImage;
  bool stsData=false;

  getUser() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      await FirebaseAuth.instance.currentUser().then((onValue4) async {
        setState(() {
          idUser=onValue4.uid;
        });
        await Firestore.instance.collection('data_ktp_afiliasi').document(onValue4.uid).get().then((onValue){
          if (onValue.exists) {
            setState(() {
              strNik=onValue.data['nik'];
              strNama=onValue.data['nama'];
              strAlamat=onValue.data['alamat'];
              strNoHp=onValue.data['no_hp'];

              ctrNik..text=onValue.data['nik'].toString();
              ctrNama..text=onValue.data['nama'].toString();
              ctrAlamat..text=onValue.data['alamat'].toString();
              ctrNoHp..text=onValue.data['no_hp'].toString();

              urlImage=onValue.data['foto_ktp'].toString();
              stsData=true;
            });
          }
        });
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
    ctrNik.dispose();
    ctrNama.dispose();
    ctrAlamat.dispose();
    ctrNoHp.dispose();
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
                      ctrNik..text=strNik;
                      ctrNama..text=strNama;
                      ctrAlamat..text=strAlamat;
                      ctrNoHp..text=strNoHp;
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
                      ctrNik..text=strNik;
                      ctrNama..text=strNama;
                      ctrAlamat..text=strAlamat;
                      ctrNoHp..text=strNoHp;
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
        title: Text('Upload Berkas'),
        backgroundColor: CompanyColors.utama,
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom:5.0),
                child: Text('Harap mengisi NO HP dengan benar', style: TextStyle(fontSize: 12.0, color: Colors.red, fontWeight: FontWeight.w400),),
              ),
              UploadImageCustom(title: 'Upload KTP', subtitle: 'Upload KTP anda',
                image: _image, imageGet: getImage, urlImage:urlImage,
              ),
              CustomForm(title: 'NIK', subtitle: 'NIK Sesuai KTP', ctr: ctrNik, maxLength: 17,
                onChange: (value){
                  setState(()=>strNik=value);
                }, justNumber: true,
              ),
              CustomForm(title: 'Nama', subtitle: 'Nama Sesuai KTP', ctr: ctrNama, maxLength: 50,
                onChange: (value){
                  setState(()=>strNama=value);
                },
              ),
              CustomForm(title: 'Alamat', subtitle: 'Alamat Sesuai KTP', ctr: ctrAlamat, maxLength: 100,
                onChange: (value){
                  setState(()=>strAlamat=value);
                },
              ),
              CustomForm(title: 'No HP', subtitle: 'No HP yang sesuai diawali dengan 0', ctr: ctrNoHp, maxLength: 12,
                onChange: (value){
                  setState(()=>strNoHp=value);
                }, justNumber: true,
              ),
              BtnLanjutDataDiri(
                strNik:strNik,
                strNama:strNama,
                strAlamat:strAlamat,
                strNoHp:strNoHp,
                image:_image,
                idUser: idUser,
                stsData:stsData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}