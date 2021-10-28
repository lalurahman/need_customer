import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:need_customer/theme/companycolors.dart';

class PengaturanProfile extends StatefulWidget {
  PengaturanProfile({Key key, @required this.idUser}) : super(key: key);

  @override
  _PengaturanProfileState createState() => _PengaturanProfileState();
  final String idUser;
}

class _PengaturanProfileState extends State<PengaturanProfile> {
  TextEditingController ctrEmail = TextEditingController();
  TextEditingController ctrNama = TextEditingController();
  TextEditingController ctrHp = TextEditingController();
  String errEmail, errNama, errHp;
  String strEmail, strNama, strHp;
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    ctrEmail.dispose();
    ctrNama.dispose();
    ctrHp.dispose();
  }
  @override
  void initState() {
    super.initState();
    ctrEmail = TextEditingController();
    ctrNama = TextEditingController();
    ctrHp = TextEditingController();
    getUser();
  }
  getUser() async {
    await Firestore.instance.collection('data_customer').document(widget.idUser.toString()).get().then((onData){
      if (onData.exists) {
        if(!mounted) return;
        ctrEmail..text=onData.data['email'];
        ctrNama..text=onData.data['name'];
        strEmail = onData.data['email'];
        strNama = onData.data['name'];
        if(onData.data['no_hp']!=null)ctrHp..text=onData.data['no_hp'];
        if(onData.data['no_hp']!=null)strHp=onData.data['no_hp'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Akun', style: TextStyle(fontSize: 16.0),),
        backgroundColor: CompanyColors.utama,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:10.0, left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customInput(false, Icons.alternate_email, ctrEmail, 'Email Anda', (val){
                setState(() => strEmail = val);
              }, false, 20, null, errEmail),
              Divider(color: Colors.black45,),
              customInput(true, Icons.person, ctrNama, 'Nama', (val){
                setState(() => strNama = val);
                setState(() {
                  if (val.isEmpty) {errNama = 'Nama Tidak Boleh Kosong';}else{errNama = null;}
                });
              }, false, 20, null, errNama),
              customInput(true, Icons.call, ctrHp, 'Nomor HP', (val){
                setState(() => strHp = val);
                if (val.isEmpty) {errHp = 'Nomor HP Tidak Boleh Kosong';
                }else if (val.length<11) {
                  errHp = 'Nomor HP Tidak Valid';
                }else if (val.substring(0, 1).toString()!='0'){
                  errHp = 'Nomor HP Tidak Valid';
                }else{
                  errHp = null;
                }
              }, true, 12, 'Contoh format : 081234543212', errHp),
              simpanBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget simpanBtn(){
    return GestureDetector(
      onTap: () async {
        if (!loading) {
          setState(() => loading = true);
          String errnya;
          setState(() {
            errEmail = null;
            errHp = null;
            errNama = null;
          });
          if (strHp.substring(0, 1).toString()!='0') {
            setState(() => errHp = 'Nomor HP Tidak Valid');
            errnya = 'Nomor HP Tidak Valid';
          }
          if(strHp.length<11){
            setState(() => errHp = 'Nomor HP Tidak Valid');
            errnya = 'Nomor HP Tidak Valid';
          }
          if(strHp.isEmpty){
            setState(() => errHp = 'Nomor HP Tidak Boleh Kosong');
            errnya = 'Nomor HP Tidak Boleh Kosong';
          }
          if (strNama.isEmpty) {
            setState(() => errNama = 'Nama Tidak Boleh Kosong');
            errnya = 'Nama Tidak Boleh Kosong';
          }
          if(errnya!=null){
            errorMessage(errnya);
            setState(() => loading = false);
          }else{
            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.SUCCES,
              tittle: 'Peringatan',
              desc: 'Yakin Ingin Mengubah Data Anda?',
              btnCancelText: 'Tidak',
              btnCancelOnPress: (){},
              btnOkText: 'Iya',
              btnOkOnPress: () async {
                String nm = strNama.toString();
                String hp = strHp.toString();
                Map<String, dynamic> dataUpdate = {'name':nm, 'no_hp':hp, 'updated_at':DateTime.now()};
                await Firestore.instance.collection('data_customer').document(widget.idUser.toString()).updateData(dataUpdate).then((onValue){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.SUCCES,
                    tittle: 'Info',
                    desc: 'Berhasil Diubah',
                    btnOkText: 'OK',
                    btnOkOnPress: (){},
                  ).show();
                  setState(() => loading = false);
                });
              }
            ).show();
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(5.0), boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 2.0), ]),
        child: Center(child: Text('UBAH DATA', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),)),
      ),
    );
  }

  errorMessage(String title){
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      tittle: 'Peringatan',
      desc: title.toString(),
      btnCancelText: 'OK',
      btnCancelOnPress: (){},
    ).show();
  }

  Widget customInput(bool enable, IconData icon, TextEditingController ctr, String hint, Function(String) fc, bool jm, int max, String frmt, String err){
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text('Email Anda', style: TextStyle(fontSize: 12.0, color: Colors.grey),),
          Container(
            // height: 40.0,
            margin: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: ctr,
              enabled: enable,
              onChanged: fc,
              style: TextStyle(fontSize: 15.0),
              keyboardType: (jm)?TextInputType.number:TextInputType.text,
              inputFormatters: (jm)?<TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(max),
              ]:<TextInputFormatter>[
                LengthLimitingTextInputFormatter(max),
              ],
              decoration: InputDecoration(
                prefixIcon: Container(width: 10.0,
                  decoration: BoxDecoration(color: CompanyColors.utama, borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0))), 
                  margin: EdgeInsets.only(right: 5.0),child: Center(child: Icon(icon, color: Colors.white,))),
                prefixStyle: TextStyle(),
                contentPadding: EdgeInsets.only(bottom: 0.0, left: 0.0, right: 0.0, top: 0.0),
                filled: true,
                fillColor: CompanyColors.utama.withOpacity(.05),
                border: OutlineInputBorder(),
                hintText: hint,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: CompanyColors.utama.withOpacity(.2))),
                hintStyle: TextStyle(fontSize: 15.0),
                errorText: err,
                errorStyle: TextStyle(color: Colors.red),
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
          (frmt==null)?Container():
          Container(margin: EdgeInsets.only(top: 5.0), child: Text(frmt, style: TextStyle(color: Colors.grey, fontSize: 12.0),))
        ],
      ),
    );
  }
} 