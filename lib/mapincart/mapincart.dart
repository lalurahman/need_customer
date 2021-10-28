import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:need_customer/theme/companycolors.dart';

class MapInCart extends StatefulWidget {
  MapInCart({Key key, @required this.idDepot, @required this.idUser}) : super(key: key);
  final String idDepot, idUser;

  @override
  _MapInCartState createState() => _MapInCartState();
}

class _MapInCartState extends State<MapInCart> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  bool searchSts = false;
  Position myPosition=Position(latitude: -5.147665, longitude: 119.43273);
  Position locationDepot=Position(latitude: -5.147665, longitude: 119.43273);
  int ongkir = 0, minJarak=0, maxJarak=0;
  bool loading=false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.147665, 119.43273),
    zoom: 14.4746,
  );

  @override
  void initState() { 
    super.initState();
    getExisLoaction().then((onValue){
      getOngkir().then((onValue){
        getLocationDepot().then((onValue){
        });
      });
    });
  }
  Future getLocationDepot() async {
    await Firestore.instance.collection('data_mitra').document(widget.idDepot).get().then((onValue){
      if (onValue.exists) {
        if (onValue.data['latlong']!=null) {
          GeoPoint gp = onValue.data['latlong'];
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
        setState(() {
          ongkir = onValue.data['ongkir']; 
          minJarak = onValue.data['min']; 
          maxJarak = onValue.data['max'];
        });
      }
    });
  }
  save() async {
    if (!loading) {
      setState(() {
        loading=true;
      });
      await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).get().then((onValue) async {
        if (onValue.exists) {
          final coordinates = new Coordinates(myPosition.latitude, myPosition.longitude);
          List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          Address first = addresses.first;
          double distanceInMeters = await Geolocator().distanceBetween(myPosition.latitude, myPosition.longitude, locationDepot.latitude, locationDepot.longitude);
          int jarakReal = ((distanceInMeters / minJarak).round()==0)?1:(distanceInMeters / minJarak).round();
          int ongkirReal = jarakReal*ongkir;
          if (distanceInMeters<=maxJarak) {
            await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).updateData({
              'latlong':GeoPoint(myPosition.latitude, myPosition.longitude),
              'alamat':first.addressLine,
              'jarak_kilo':jarakReal,
              'ongkir':ongkirReal,
            }); 
            Navigator.pop(context);
          }else{
            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.ERROR,
              tittle: 'Peringatan',
              desc:   'Jarak Terlalu Jauh',
              btnCancelOnPress: (){},
            ).show();
          }
        }
      });
      setState(() {
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Tentukan Lokasi'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onTap: (ll){
              _add(ll);
            },
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
            },
            markers: markers,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      searchSts=true;
                    });

                    await PlacesAutocomplete.show(
                      context: context,
                      apiKey: "AIzaSyAIBWT9Mi6oyT-X-zuB7P10364U2VMiPcg",
                      mode: Mode.overlay, // Mode.fullscreen
                      language: "fr",
                      components: [new Component(Component.country, "idn")]).then((onValue) async {
                        if (onValue!=null) {
                          GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyAIBWT9Mi6oyT-X-zuB7P10364U2VMiPcg");
                          PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(onValue.placeId);
                          final lat = detail.result.geometry.location.lat;
                          final lng = detail.result.geometry.location.lng;
                          _add(LatLng(lat, lng));
                        }
                        setState(() {
                          searchSts=false;
                        });
                      });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                    padding: EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 3.0)
                      ]
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        Text('   Cari Alamat Kamu Disini', style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
                (markers.length==0)?Container():
                GestureDetector(
                  onTap: () async {
                    save();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                    padding: EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      color: CompanyColors.utama,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 3.0)
                      ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text((loading)?'loading..':'Tentukan Alamat Disini', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Future myLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position!=null) {
      setState(() {
        myPosition=position;
      });
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19.151926040649414)));
    }
  }

  Future getExisLoaction() async {
    await Firestore.instance.collection('cart').document(widget.idUser).collection('detail_depot').document(widget.idDepot).get().then((onValue) async {
      if (onValue.exists) {
        if (onValue.data['latlong']!=null&&onValue.data['alamat']!=null) {
          GeoPoint gp = onValue.data['latlong'];
          await _add(LatLng(gp.latitude, gp.longitude)).then((onValue) async {
            
          });
        }
      }else{
        myLocation().then((v){
        });
      }
    });
  }

  Future _add(LatLng latlng) async {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('me'),
          position: latlng,
          icon: BitmapDescriptor.defaultMarker,
        )
      );
      myPosition=Position(latitude: latlng.latitude, longitude: latlng.longitude);
    });
    CameraPosition _kLake = CameraPosition(target: latlng, zoom: 17.0);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}