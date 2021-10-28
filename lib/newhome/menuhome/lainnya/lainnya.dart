import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/listdepot/listdepot.dart';
import 'package:need_customer/newhome/menuhome/lainnya/lainnya.dart';
import 'package:need_customer/theme/companycolors.dart';

class Lainnya extends StatefulWidget {
  Lainnya({Key key}) : super(key: key);

  @override
  _LainnyaState createState() => _LainnyaState();
}

class _LainnyaState extends State<Lainnya> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: CompanyColors.utama, title: Text('Menu Lainnya'),),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 140.0,
            //   child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0, bottom: 10.0),
              // height: 160.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1.0)
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Text('List Menu', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                          children: <Widget>[
                            wdg('ORDER GALON', 'assets/images/galon.png', (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: false, ufOnly: false, aquaOnly: false,
                                  clubOnly: false, cleoOnly: false, vitOnly: false,)),
                              );
                            }, true, true),
                            wdg('CLUB', 'assets/images/club.png', (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: false, ufOnly: false, aquaOnly: false,
                                  clubOnly: true, cleoOnly: false, vitOnly: false,)),
                              );
                            }, true, true),
                            wdg('CLEO', 'assets/images/cleo.png', (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: false, ufOnly: false, aquaOnly: false,
                                  clubOnly: false, cleoOnly: true, vitOnly: false,)),
                              );
                            }, true, true),
                            wdg('VIT', 'assets/images/vit.png', (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: false, ufOnly: false, aquaOnly: false,
                                  clubOnly: false, cleoOnly: false, vitOnly: true,)),
                              );
                            }, true, true),
                          ]
                        ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          wdg('AQUA', 'assets/images/aqua.png', (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: false, ufOnly: false, aquaOnly: true,
                                clubOnly: false, cleoOnly: false, vitOnly: false,)),
                            );
                          }, true, true),
                          wdg('RO', 'assets/images/menuro.png', (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: true, ufOnly: false, aquaOnly: false,
                                clubOnly: false, cleoOnly: false, vitOnly: false,)),
                            );
                          }, true, true),
                          wdg('UF', 'assets/images/menuuf.png', (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: false, roOnly: false, ufOnly: true, aquaOnly: false,
                                clubOnly: false, cleoOnly: false, vitOnly: false,)),
                            );
                          }, true, true),
                          wdg('ALKALINE', 'assets/images/menual.png', (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ListDepot(brOnly: false, alOnly: true, roOnly: false, ufOnly: false, aquaOnly: false,
                                clubOnly: false, cleoOnly: false, vitOnly: false,)),
                            );
                          }, true, true),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          wdg('LAUNDRY', 'assets/images/laundry.jpeg', (){

                          }, false, true),
                          wdg('PASAR', 'assets/images/pasar.png', (){

                          }, false, true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wdg(String title, String url, Function fc, bool aktif, lainnya){
    return Expanded(
      child: GestureDetector(
        onTap: (aktif)?fc:(){
          // print((MediaQuery.of(context).size.width-290).toString());
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.INFO,
            tittle: 'Peringatan',
            desc:   'Belum Dapat Digunakan',
            btnOkOnPress: (){},
            btnOkText: 'OKE'
          ).show();
        },
        child: Container(
          // margin: EdgeInsets.only(right: 10.0, left: 2.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width-290,
                height: MediaQuery.of(context).size.width-290,
                margin: EdgeInsets.only(top: 10.0, bottom: 2.0),
                decoration: BoxDecoration(color: (!lainnya)?CompanyColors.utama:Colors.white, boxShadow: [BoxShadow(color: Colors.black38.withOpacity(.3), blurRadius: 1.0)], borderRadius: BorderRadius.circular(10.0)),
                child: (!lainnya)?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.view_module, color: Colors.white, size: 30.0),
                    Text('Lainnya', style: TextStyle(color: Colors.white, fontSize: 12.0),)
                  ],
                )
                :ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(url.toString(), fit: BoxFit.cover,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Text(title.toString(), style: TextStyle(fontSize: 10.0),),
              )
            ],
          ),
        ),
      ),
    );
  }
}