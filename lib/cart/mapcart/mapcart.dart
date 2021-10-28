import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:need_customer/mapincart/mapincart.dart';

class MapCart extends StatefulWidget {
  MapCart({Key key, @required this.idDepot, @required this.idUser, @required this.myPosition}) : super(key: key);
  final String idDepot, idUser;
  final Position myPosition;
  @override
  _MapCartState createState() => _MapCartState();
}

class _MapCartState extends State<MapCart> {
  Position myPosition=Position(latitude: -5.147665, longitude: 119.43273);
  Position locationDepot=Position(latitude: -5.147665, longitude: 119.43273);
  int ongkir = 0, minJarak=0, maxJarak=0;
  @override
  void initState() { 
    super.initState();
    if (!mounted) return;
    ongkir = 0; 
    minJarak=0; 
    maxJarak=0;
    myLocation().then((v){
      getOngkir().then((onValue){
        getLocationDepot().then((onValue){
          getExisLoaction();
        });
      });
    });
  }

  Future myLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position!=null) {
      if (!mounted) return;
      setState(() {
        myPosition=position;
      });
    }
  }
  Future getLocationDepot() async {
    await Firestore.instance.collection('data_mitra').document(widget.idDepot).get().then((onValue){
      if (onValue.exists) {
        if (onValue.data['latlong']!=null) {
          GeoPoint gp = onValue.data['latlong'];
          if (!mounted) return;
          setState(() {
            locationDepot = Position(latitude: gp.latitude, longitude: gp.longitude);
          });
        }
      }
    });
  }
  Future getOngkir() async {
    await Firestore.instance.collection('ketentuan').document('ongkir').get().then((onValue){
      if (onValue.exists) {
        if (!mounted) return;
        setState(() {
          ongkir = onValue.data['ongkir']; 
          minJarak = onValue.data['min']; 
          maxJarak = onValue.data['max'];
        });
      }
    });
  }
  getExisLoaction() async {
    await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).get().then((onValue) async {
      if (onValue.exists) {
        if (onValue.data['latlong']==null&&onValue.data['alamat']==null) {
          final coordinates = new Coordinates((widget.myPosition!=null)?widget.myPosition.latitude:myPosition.latitude, (widget.myPosition!=null)?widget.myPosition.longitude:myPosition.longitude);
          List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          Address first = addresses.first;
          double distanceInMeters = await Geolocator().distanceBetween((widget.myPosition!=null)?widget.myPosition.latitude:myPosition.latitude, (widget.myPosition!=null)?widget.myPosition.longitude:myPosition.longitude, locationDepot.latitude, locationDepot.longitude);
          int jarakReal = ((distanceInMeters / minJarak).round()==0)?1:(distanceInMeters / minJarak).round();
          int ongkirReal = jarakReal*ongkir;
          print(ongkirReal);
          if (distanceInMeters<=maxJarak) {
            await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
              'latlong':GeoPoint((widget.myPosition!=null)?widget.myPosition.latitude:myPosition.latitude, (widget.myPosition!=null)?widget.myPosition.longitude:myPosition.longitude),
              'alamat':first.addressLine,
              'jarak_kilo':jarakReal,
              'ongkir':ongkirReal,
            }); 
          }else{
            await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
              'ongkir':0,
            }); 
          }
        }
      }
    });
  }

  getLocationExis() async {
    await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).get().then((onValue){
      if (onValue.exists) {
        if (onValue.data['alamat']!=null&&onValue.data['latlong']!=null) {
          
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        String alamat='...';
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            alamat=(snapshot.data.data['alamat']!=null)?snapshot.data.data['alamat']:'Lokasi Belum Ditentukan';
          }
        }
        return wdg(alamat);
      },
    );
  }

  Widget wdg(String alamat){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MapInCart(idDepot: widget.idDepot, idUser: widget.idUser,)));
      },
      child: Container(
        padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            //   child: Text('Detail Tujuan', style: TextStyle(fontWeight: FontWeight.w600),),
            // ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 60.0, width: 60.0,
                    margin: EdgeInsets.only(left: .0),
                    decoration: BoxDecoration(
                      // color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Image.asset('assets/images/googlemapsicon.png', fit: BoxFit.cover,),
                    // child: Center(
                    //   child: Icon(Icons.map, color: Colors.white, size: 30.0,),
                    // ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: .0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Lokasi Tujuan', style: TextStyle(color: Colors.grey, fontSize: 11.0),),
                        Container(
                          width: MediaQuery.of(context).size.width-150,
                          child: Text(alamat.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.7),)),
                      ],
                    ),
                  ),
                  Expanded(child: Container(),),
                  Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child: Icon(Icons.gps_fixed),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}