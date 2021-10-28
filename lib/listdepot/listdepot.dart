import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:need_customer/akses/akseslokasi.dart';
import 'package:need_customer/listdepot/listmenudepot/listmenudepot.dart';
import 'package:need_customer/listdepot/listmenudepot/loading/loadinglist.dart';
import 'package:need_customer/listdepot/maplist/maplist.dart';
import 'package:need_customer/theme/companycolors.dart';
import 'package:permission_handler/permission_handler.dart';

class ListDepot extends StatefulWidget {
  ListDepot({Key key, @required this.roOnly, @required this.alOnly, @required this.ufOnly, @required this.brOnly,
    @required this.aquaOnly, @required this.clubOnly, @required this.cleoOnly, @required this.vitOnly
  }) : super(key: key);
  final bool roOnly;
  final bool alOnly;
  final bool ufOnly;
  final bool brOnly;
  final bool aquaOnly;
  final bool clubOnly;
  final bool cleoOnly;
  final bool vitOnly;
  @override
  _ListDepotState createState() => _ListDepotState();
}

class _ListDepotState extends State<ListDepot> {
  bool lokasi = false, loading=true, loading2=false;
  Widget ww=LoadingList();
  Position myPosition;
  bool roOnly=false;
  bool alOnly=false;
  bool ufOnly=false;
  bool brOnly=false;
  bool aquaOnly=false;
  bool clubOnly=false;
  bool cleoOnly=false;
  bool vitOnly=false;
  @override
  void initState() { 
    super.initState();
    aksesLokasi();
    roOnly=widget.roOnly;
    alOnly=widget.alOnly;
    ufOnly=widget.ufOnly;
    brOnly=widget.brOnly;
    aquaOnly=widget.aquaOnly;
    clubOnly=widget.clubOnly;
    cleoOnly=widget.cleoOnly;
    vitOnly=widget.vitOnly;
    ww=ListMenuDepot(myPosition:myPosition, roOnly: widget.roOnly, alOnly: widget.alOnly, ufOnly: widget.ufOnly, brOnly: widget.brOnly, aquaOnly: widget.aquaOnly,
      clubOnly: widget.clubOnly, cleoOnly: widget.cleoOnly, vitOnly: widget.vitOnly,
    );
  }
  aksesLokasi() async {
    await Permission.location.status.then((onValue){
      if (onValue.isGranted) {
        setState(()=>lokasi=true);
      }
      setState(()=>loading=false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return(loading)?Scaffold(body: LoadingList(),):(!lokasi)?AksesLokasi(
      fc: () async {
        // print('object');
        if(await Permission.location.request().isGranted){
          setState(() {
            lokasi=true;
          });
        }else{
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            tittle: 'Peringatan',
            desc: 'Kami Tidak Dapat\n Mengakses Lokasi Anda',
            btnOkOnPress: () {},
          ).show();
        }
      },
    ):Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('List Depot Terdekat', style: TextStyle(fontSize: 17.0),),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:.0, left: .0),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  loading = true;
                  loading2 = true;
                });
                Position lokasi = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapList()),
                );
                setState(() {
                  loading = false;
                  loading2 = false;
                });
                if (lokasi!=null) {
                  setState(() {
                    ww=LoadingList();
                    myPosition=lokasi;
                  });
                  var duration = const Duration(seconds: 3);
                  Timer(duration, (){
                    setState(() {
                      ww=ListMenuDepot(myPosition:lokasi, roOnly: roOnly, alOnly: alOnly, ufOnly: ufOnly, brOnly: brOnly, aquaOnly: widget.aquaOnly,
                        clubOnly: widget.clubOnly, cleoOnly: widget.cleoOnly, vitOnly: widget.vitOnly,
                      );
                    });
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right:13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.near_me),
                    Text('map', style: TextStyle(fontSize: 10.0),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ww,
          wdg(),
        ],
      ),
    );
  }

  Widget wdg(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 58.0,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 3.0)
      ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(width: 10.0,),
            (!alOnly&&!roOnly&&!brOnly&&!ufOnly&&!aquaOnly&&!clubOnly&&!cleoOnly&&!vitOnly)?
            wdg2('ALL', Colors.white, Colors.orange, false, false, false, false, false, false, false, false):
            wdg2('ALL', Colors.grey[700], Colors.grey[200], false, false, false, false, false, false, false, false),
            (roOnly)?
            wdg2('Reverse Osmosis', Colors.white, Colors.orange, false, false, false, false, false, false, false, false):
            wdg2('Reverse Osmosis', Colors.grey[700], Colors.grey[200], true, false, false, false, false, false, false, false),
            (ufOnly)?
            wdg2('Ultra Filter', Colors.white, Colors.orange, false, false, false, false, false, false, false, false):
            wdg2('Ultra Filter', Colors.grey[700], Colors.grey[200], false, false, true, false, false, false, false, false),
            (alOnly)?
            wdg2('Alkaline', Colors.white, Colors.orange, false, false, false, false, false, false, false, false):
            wdg2('Alkaline', Colors.grey[700], Colors.grey[200], false, true, false, false, false, false, false, false),
            (brOnly)?
            wdg2('Brand', Colors.white, Colors.orange, false, false, false, false, false, false, false, false):
            wdg2('Brand', Colors.grey[700], Colors.grey[200], false, false, false, true, false, false, false, false),
          ],
        ),
      ),
    );
  }

  Widget wdg2(String title, Color clr, Color clr2, bool roOnly2, bool alOnly2, bool ufOnly2, bool brOnly2, bool aquaOnly2, bool clubOnly2, bool cleoOnly2, bool vitOnly2){
    return GestureDetector(
      onTap: (){
        if (!loading2) {
          setState(() {
            ww=LoadingList();
            loading2=true;
            roOnly=roOnly2; alOnly=alOnly2; ufOnly=ufOnly2; brOnly=brOnly2;
            aquaOnly=aquaOnly2; clubOnly=clubOnly2; cleoOnly=cleoOnly2; vitOnly=vitOnly2;
          });
          var duration = const Duration(seconds: 2);
          Timer(duration, (){
            setState(() {
              loading2=false;
              ww=ListMenuDepot(myPosition:myPosition, roOnly: roOnly2, alOnly: alOnly2, ufOnly: ufOnly2, brOnly: brOnly2, aquaOnly: aquaOnly2,
                clubOnly: clubOnly2, cleoOnly: cleoOnly2, vitOnly: vitOnly2,);
            });
          });
        }
      },
      child: Container(
        // width: 50.0,
        height: 30.0,
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        decoration: BoxDecoration(color: clr2, borderRadius: BorderRadius.circular(100.0)),
        child: Center(child: Text(title.toString(), style: TextStyle(color: clr))),
      ),
    );
  }
}