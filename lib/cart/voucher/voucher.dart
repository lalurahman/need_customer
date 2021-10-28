import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:need_customer/detailvoucher/detailvoucher.dart';
import 'package:need_customer/listpromo/listpromo.dart';
import 'package:need_customer/theme/companycolors.dart';

class Voucher extends StatefulWidget {
  Voucher({Key key, @required this.idDepot, this.idUser}) : super(key: key);
  final String idDepot;
  final String idUser;
  @override
  _VoucherState createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              String kode;
              if (snapshot.connectionState==ConnectionState.active) {
                if (snapshot.data.exists) {
                  if (snapshot.data.data['voucher']!=null) {
                    kode = snapshot.data.data['voucher'];
                  }
                }
              }
              return wdg(kode, snapshot.data);
            },
          ),
        ],
      ),
    );
  }

  Widget wdg(String kode, DocumentSnapshot data){
    return GestureDetector(
      onTap: (){
        if(kode!=null){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>DetailVoucher(idPromo: kode.toString(),)));
        }else{
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ListPromo()));
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Text('Detail Voucher', style: TextStyle(fontWeight: FontWeight.w600),),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ListPromo()));
                    },
                    child: Text('List Voucher', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: .0,  bottom: .0),
              child: DottedBorder(
                color: Colors.black,
                borderType: BorderType.RRect,
                radius: Radius.circular(20.0),
                strokeWidth: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('ID Voucher', style: TextStyle(fontSize: 8.0, color: Colors.grey),),
                            (kode==null)?
                            Container(
                              width: MediaQuery.of(context).size.width-180,
                              // color: Colors.red,
                              child: Text('Masukkan Kode Voucher', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey),)):
                            Container(
                              width: MediaQuery.of(context).size.width-180,
                              // color: Colors.red,
                              child: Text('${kode.toString()}', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600),)),
                          ],
                        ),
                        Expanded(child: Container()),
                        (kode==null)?Container():
                        GestureDetector(
                          onTap: () async {
                            if (!loading) {
                              setState(()=>loading=true);
                              Map<String, dynamic> dt = data.data;
                              await dt.remove('voucher');
                              await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).setData(dt).then((onValue){
                                
                              });
                              setState(()=>loading=false);
                            }
                          },
                          child: Container(
                            // width: 40.0, height: 40.0,
                            decoration: BoxDecoration(
                              // color:Colors.blue,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: (loading)?Container(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(),
                            ):Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        ),
                        (kode!=null)?Container():
                        GestureDetector(
                          onTap: () async {
                            ClipboardData dataP = await Clipboard.getData('text/plain');
                            await Firestore.instance.collection('voucher').document(dataP.text.toString()).get().then((onValue) async {
                              if (!loading) {
                                setState(()=>loading=true);
                                if (onValue.exists) {
                                  await Firestore.instance.collection('data_customer').document(widget.idUser).get().then((onValue22) async {
                                    if (onValue22.exists) {
                                      if (onValue.data['point']<=onValue22.data['point']) {
                                      if (onValue.data['status']) {
                                      if (onValue.data['stok']>0) {
                                      if (onValue.data['sekali_pakai']) {
                                        await Firestore.instance.collection('final_transaksi').where('id_user', isEqualTo: widget.idUser).where('voucher', isEqualTo: onValue.documentID).getDocuments().then((onValue223) async {
                                          if(onValue223.documents.length>0) {
                                            peringatan('Voucher sudah terpakai');
                                          }else{
                                            await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({'voucher':dataP.text.toString()}) .then((onValue){});
                                          }
                                        });
                                      }else{
                                        await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({'voucher':dataP.text.toString()}) .then((onValue){});
                                      }
                                      }else{peringatan('Voucher sudah habis');}
                                      }else{peringatan('Voucher tidak aktif');}
                                      }else{peringatan('Point anda tidak cukup');}
                                    }
                                  }); 
                                }else{
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.SCALE,
                                    dialogType: DialogType.ERROR,
                                    tittle: 'Peringatan',
                                    desc:   'Voucher tidak ditemuka',
                                    btnCancelOnPress: () {},
                                    btnCancelText: 'OK',
                                    btnOkOnPress: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ListPromo()));        
                                    },
                                    btnOkText: 'VOUCHER',
                                  ).show();
                                }
                                setState(()=>loading=false);
                              }
                            });
                          },
                          child: Container(
                            // width: 40.0, height: 40.0,
                            decoration: BoxDecoration(
                              // color:Colors.blue,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: (loading)?Container(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(),
                            ):Icon(Icons.add_box, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Divider()
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            //   margin: EdgeInsets.only(left: 10.0, right: 10.0),
            //   decoration: BoxDecoration(color: CompanyColors.utama, borderRadius: BorderRadius.circular(5.0)),
            //   child: Column(
            //     children: <Widget>[
            //       Text('Kode Voucher Yang Digunakan', style: TextStyle(color: Colors.white, fontSize: 12.0),),
            //       Text(kode.toString(), style: TextStyle(color: Colors.white, fontSize: 18.0),),
            //     ],
            //   ),
            // )
          ],
        )
      ),
    );
  }

  peringatan(String title){
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      tittle: 'Peringatan',
      desc: title.toString(),
      btnCancelOnPress: () {},
      btnCancelText: 'OK',
    ).show();
  }
}