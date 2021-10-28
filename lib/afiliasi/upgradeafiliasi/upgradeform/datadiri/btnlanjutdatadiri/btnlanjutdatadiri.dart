import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class BtnLanjutDataDiri extends StatefulWidget {
  BtnLanjutDataDiri({Key key, @required this.image, @required this.stsData, @required this.idUser, @required this.strNoHp, @required this.strAlamat, @required this.strNik, @required this.strNama}) : super(key: key);
  final String strNik,strNama,strAlamat,idUser,strNoHp;
  final File image;
  final bool stsData;
  @override
  _BtnLanjutDataDiriState createState() => _BtnLanjutDataDiriState();
}

class _BtnLanjutDataDiriState extends State<BtnLanjutDataDiri> {
  bool loading=false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!loading) {
          setState(()=>loading=true);
          if (validasi()) {
            if (widget.image==null) {
              Map<String, dynamic> dataSimpan = {
                'nik':widget.strNik.toString(),
                'nama':widget.strNama.toString(),
                'alamat':widget.strAlamat.toString(),
                'no_hp':widget.strNoHp.toString(),
              };
              await Firestore.instance.collection('data_ktp_afiliasi').document(widget.idUser).updateData(dataSimpan).then((onValue){
                setState(()=>loading=false);
              });
              Navigator.pop(context);
            }else{
              await compressAndGetFile(widget.image,widget.image.path).then((hasilKompres) async {
                final StorageReference storageReference = FirebaseStorage().ref().child('foto_ktp_afiliasi/${widget.idUser.toString()}.jpg');
                final StorageUploadTask uploadTask = storageReference.putData(hasilKompres.readAsBytesSync());
                final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
                  print('EVENT ${event.type}');
                });
                await uploadTask.onComplete;
                streamSubscription.cancel();
                String photoUrl, path;
                await storageReference.getDownloadURL().then((photoUrlF)=>photoUrl=photoUrlF);
                await storageReference.getPath().then((pathF)=>path=pathF);
                Map<String, dynamic> dataSimpan = {
                  'foto_ktp':photoUrl,
                  'foto_ktp_path':path,
                  'nik':widget.strNik.toString(),
                  'nama':widget.strNama.toString(),
                  'alamat':widget.strAlamat.toString(),
                  'no_hp':widget.strNoHp.toString(),
                };
                await Firestore.instance.collection('data_ktp_afiliasi').document(widget.idUser).setData(dataSimpan).then((onValue){
                  setState(()=>loading=false);
                });
                Navigator.pop(context);
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){return AddMitraMap(dataSimpan:dataSimpan);}));
              });
            }
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Center(
          child: Text((loading)?'loading..':'Simpan Data', style: TextStyle(color: Colors.white, fontSize: 15.0),),
        ),
      ),
    );
  }

  bool validasi(){
    String peringatan;
    peringatan=
      (widget.strNik==''||widget.strNik==null)?'NIK':
      (widget.strNama==''||widget.strNama==null)?'Nama':
      (widget.strAlamat==''||widget.strAlamat==null)?'Alamat':
      (widget.strNoHp==''||widget.strNoHp==null)?'NO HP':
      (widget.image==null)?(!widget.stsData)?'Foto KTP':null:null;
    
    return (peringatan!=null)?awsDialog('${peringatan.toString()} Tidak Boleh Kosong'):true;
  }

  bool awsDialog(String title){
    AwesomeDialog(context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      tittle: 'Peringatan',
      desc: title,
      btnCancelText: 'OKE',
      btnCancelOnPress: () {},
    ).show();
    setState(()=>loading=false);
    return false;
  }

  // compress file and get file.
  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, '${targetPath.toString()}.jpeg',
      quality: 30,
      format: CompressFormat.jpeg,
      autoCorrectionAngle: true,
      keepExif: true
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }
}