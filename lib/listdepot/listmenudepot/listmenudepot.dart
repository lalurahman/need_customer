import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:need_customer/detaildepot/detaildepot.dart';
import 'package:need_customer/listdepot/listmenudepot/kosong/kosonglist.dart';
import 'package:need_customer/listdepot/listmenudepot/loading/loadinglist.dart';
import 'package:need_customer/listdepot/listmenudepot/nolokasi/nolokasi.dart';
import 'package:need_customer/listpromo/listpromo.dart';
import 'package:need_customer/theme/companycolors.dart';

class ListMenuDepot extends StatefulWidget {
  ListMenuDepot({Key key, @required this.myPosition, @required this.roOnly, @required this.alOnly, @required this.ufOnly, @required this.brOnly,
    @required this.aquaOnly, @required this.clubOnly, @required this.cleoOnly, @required this.vitOnly
  }) : super(key: key);
  final Position myPosition;
  final bool roOnly;
  final bool alOnly;
  final bool ufOnly;
  final bool brOnly;
  final bool aquaOnly;
  final bool clubOnly;
  final bool cleoOnly;
  final bool vitOnly;
  @override
  _ListMenuDepotState createState() => _ListMenuDepotState();
}

class _ListMenuDepotState extends State<ListMenuDepot> {
  Position myPosition=Position(latitude: -5.147665, longitude: 119.43273);
  Query collectionReference = Firestore.instance.collection('data_mitra');
  Widget wdgVar = Container();
  double rds = 0;
  List<Widget> listWdg = [];
  bool loading=false, noLokasi=false;
  
  Geoflutterfire geo = Geoflutterfire();
  @override
  void initState() { 
    super.initState();
    loading = true;
    noLokasi=false;
    getRadius().then((onValue){
      if(widget.myPosition==null){
        myLocation();
      }else{
        setState(() {
          myPosition=widget.myPosition;
          getData2=getData(widget.myPosition);
          getData2.resume();
        });
      }
    });
  }

  @override
  void dispose() { 
    super.dispose();
    if(getData2!=null)getData2.cancel();
  }
  myLocation() async {
    await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((onValue) async {
      if (onValue!=null) {
        setState(() {
          myPosition=onValue;
          getData2=getData(onValue);
          getData2.resume();
        });
      }else{
        setState(() {
          noLokasi = true;
          loading=false;
        });
      }
    });
  }

  StreamSubscription<List<DocumentSnapshot>>getData2;
  StreamSubscription<List<DocumentSnapshot>>getData(Position myPosition2){
    return geo.collection(collectionRef: collectionReference.reference())
    .within(center: GeoFirePoint(myPosition2.latitude, myPosition2.longitude), radius: 20, field: 'position').listen((snapshot){
      if(!mounted) return;
      setState((){
        listWdg = [];
        loading = true;
      });
      // print('disinika');
      if (snapshot.length>0) {
        int i=0;
        snapshot.forEach((f) async {
          GeoPoint lokDep = f.data['latlong'];
          Geolocator().distanceBetween(myPosition2.latitude, myPosition2.longitude, lokDep.latitude, lokDep.longitude).asStream().listen((onValue){
             double dtKL=(onValue==null)?0:onValue;
             if (dtKL<=rds) {
                dtKL=dtKL/1000;
                bool ro = (f.data['ro_status']!=null)?f.data['ro_status']:false;
                bool uf = (f.data['uf_status']!=null)?f.data['uf_status']:false;
                bool al = (f.data['al_status']!=null)?f.data['al_status']:false;
                bool br = (f.data['br_status']!=null)?f.data['br_status']:false;
                bool aqua = (f.data['aqua_status']!=null)?f.data['aqua_status']:false;
                bool club = (f.data['club_status']!=null)?f.data['club_status']:false;
                bool cleo = (f.data['cleo_status']!=null)?f.data['cleo_status']:false;
                bool vit = (f.data['vit_status']!=null)?f.data['vit_status']:false;
                double rt = (f.data['rating']==null)?4.3:f.data['rating']+.0;
                bool buka24jam = (f.data['buka_24_jam']==null)?false:f.data['buka_24_jam'];
                if(f.data['status_online'])
                if(f.data['aktifasi'])
                if (widget.roOnly==true) {
                  if(f.data['ro_status']!=null&&f.data['ro_status']==true)
                  eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                }else{
                  if (widget.ufOnly==true) {
                    if(f.data['uf_status']!=null&&f.data['uf_status']==true)
                    eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                  }else{
                    if (widget.alOnly==true) {
                      if(f.data['al_status']!=null&&f.data['al_status']==true)
                      eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                    }else{
                      if (widget.brOnly==true) {
                        if(f.data['br_status']!=null&&f.data['br_status']==true)
                        eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                      }else{
                        if (widget.aquaOnly==true) {
                          if(f.data['aqua_status']!=null&&f.data['aqua_status']==true)
                          eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                        }else{
                          if (widget.clubOnly==true) {
                            if(f.data['club_status']!=null&&f.data['club_status']==true)
                            eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                          }else{
                            if (widget.cleoOnly==true) {
                              if(f.data['cleo_status']!=null&&f.data['cleo_status']==true)
                              eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                            }else{
                              if (widget.vitOnly==true) {
                                if(f.data['vit_status']!=null&&f.data['vit_status']==true)
                                eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                              }else{
                                eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam);
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
             }
             i++;
             if (i==snapshot.length) {
              if(mounted){
                setState(() {
                  loading=false;
                });
              }
            }
            return false;
          });
          return false;
        });
      }else{
        if(mounted){
          setState(() {
            loading=false;
          });
        }
      }
    });
  }

  eksekusi(f, ro, uf, al, dtKL, rt, br, buka24jam){
    if (!mounted) return;
    setState((){
      listWdg.add(getCard(f.documentID,
          f.data['nama_depot'].toString(), f.data['alamat_depot'].toString(),
          f.data['foto_depot'],
          ro, uf, al, dtKL, rt, br, buka24jam));
      // if(loading){loading = false;}
    });
  }

  Future<bool> getRadius() async {
    await Firestore.instance.collection('ketentuan').document('jarak_radius').get().then((onValue){
      if (onValue.exists) {
        if (!mounted) return;
        setState(() {
          rds = onValue.data['value']+0.0;
        });
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return tpData();
  }


  tpData(){
    return (loading)?LoadingList():(noLokasi)?GestureDetector(
      onTap: (){
        setState(() {
          loading = true;
          noLokasi=false;
          if(getData2!=null)getData2.cancel();
        });
        getRadius().then((onValue){
          if(widget.myPosition==null){
            myLocation();
          }else{
            if (!mounted) return;
            setState(() {
              myPosition=widget.myPosition;
              getData2=getData(widget.myPosition);
              getData2.resume();
            });
          }
        });
      },
      child: NoLokasi()):
    (listWdg.length<=0)?KosongList():

    Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            vc(),
            Divider(),
            // Container(height: 16.0,),
            Column(
              children: listWdg,
            ),
          ],
        ),
      ),
    );
  }
  String voucher;
  Widget vc(){
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('voucher').document(voucher.toString()).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        bool aktif = false;
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            aktif = true;
          }
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20.0, right: 10.0),
          height: 45.0,
          margin: EdgeInsets.only(left: .0, right: .0, top: 64.0),
          decoration: BoxDecoration(color: CompanyColors.utama, 
          gradient: LinearGradient(colors: [
            (aktif)?Colors.orange:CompanyColors.utama,
            (aktif)?Colors.orange[200]:CompanyColors.utama.withOpacity(.6),
          ]),
          borderRadius: BorderRadius.circular(100.0)),
          child: Row(
            children: <Widget>[
              Text((aktif)?voucher.toString():'Bisa Lebih Murah', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () async {
                  String voucher2 = await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ListPromo()));
                  // print('vc : ${voucher2.toString()}');
                  if (voucher2!=null) {
                    setState(() {
                      voucher = voucher2.toString();
                    });
                  }
                },
                child: Container(
                  width: 110.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100.0)),
                  child: Center(child: Text('Cek Voucher', style: TextStyle(color: (aktif)?Colors.orange:CompanyColors.utama, fontWeight: FontWeight.w600),)),
                ),
              )
            ],
          ),
        );
      },
    );

  }

  Widget getCard(String id, String nmDepot, String alamat, String urlPhoto, bool ro, bool uf, bool al, double jarak, double rt, bool br, bool buka24jam) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            // myLocation();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailDepot(id:id, myPosition:widget.myPosition, voucher:voucher)),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5.0),
            color: Colors.white.withOpacity(.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0, height: 80.0,
                  decoration: BoxDecoration(color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: ShowImage(url: urlPhoto,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                       Row(
                        children: <Widget>[
                          Text((nmDepot.length<=30)?'${nmDepot.toString()} ':'${nmDepot.toString().substring(0,30)}... ', maxLines: 1, overflow: TextOverflow.clip, style: TextStyle(fontWeight: FontWeight.w700),),
                          Padding(
                            padding: const EdgeInsets.only(bottom:3.0),
                            child: Icon(Icons.verified_user, color: Colors.orange, size: 14.0,),
                          ),

                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-110,
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(alamat, style: TextStyle(color: Colors.grey, fontSize: 12.0), overflow: TextOverflow.ellipsis,)),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.star, color: Colors.orange, size: 13.0,),
                            Text(' ${rt.toString()} ', style: TextStyle(fontSize: 12.0),),
                            Icon(Icons.navigation, color: Colors.orange, size: 13.0,),
                            Text(' ${jarak.round().toString()} km', style: TextStyle(fontSize: 12.0),),
                          ],
                        )),
                      (buka24jam)?ur('BUKA 24 JAM', Colors.orange):Container(),
                      (uf||ro||al||br)?
                      // Container():Container()
                      Container(
                        width: MediaQuery.of(context).size.width-130.0,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                          children: <Widget>[
                            (uf)?ur('Ultra Filter', CompanyColors.utama):Container(),
                            (ro)?ur('RO', CompanyColors.utama):Container(),
                            (al)?ur('Alkali', CompanyColors.utama):Container(),
                            (br)?ur('Brand', CompanyColors.utama):Container(),
                            // Expanded(child: Container()),
                            // ur('Brand', CompanyColors.utama),
                          ],
                        ),),
                      )
                      :ur('No Filter', CompanyColors.utama),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget ur(String nm, Color clr){
    return Container(
      margin: EdgeInsets.only(top: 5.0, right: 5.0),
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
      decoration: BoxDecoration(color: clr.withOpacity(.8), borderRadius: BorderRadius.circular(3.0)),
      child: Center(child: Text(nm,
        style: TextStyle(fontSize: 11.0, color: Colors.white),),),
    );
  }
}

class ShowImage extends StatefulWidget {
  ShowImage({Key key, @required this.url}) : super(key: key);
  final String url;
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        placeholder: (context, url) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        filterQuality: FilterQuality.low,
        imageUrl: widget.url,
        fit: BoxFit.cover,
      ),
    );
  }
}