import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:need_customer/theme/companycolors.dart';

class MapList extends StatefulWidget {
  MapList({Key key}) : super(key: key);

  @override
  _MapListState createState() => _MapListState();
}

class _MapListState extends State<MapList> {
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
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CompanyColors.utama,
        title: Text('Tentukan Lokasi Pemesanan', style: TextStyle(fontSize: 16.0),),
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
                    Navigator.of(context).pop(myPosition);
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