import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:need_customer/theme/companycolors.dart';

class TrackingKurir extends StatefulWidget {
  TrackingKurir({Key key, @required this.dataSn}) : super(key: key);
  final DocumentSnapshot dataSn;
  @override
  _TrackingKurirState createState() => _TrackingKurirState();
}

class _TrackingKurirState extends State<TrackingKurir> {
  GoogleMapController _controller;
  Set<Marker> marker = HashSet<Marker>();
  Polyline _polyline;

  bool isMapCreate = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.147665, 119.43273),
    zoom: 17.4746,
  );

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setBimap();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    if (_getDataStrm != null) {
      _getDataStrm.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreate) {
      // changeMapMode();
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.blueGrey[900]),
      child: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        tiltGesturesEnabled: true,
        // trafficEnabled: true,
        trafficEnabled: false,
        markers: marker,
        polylines: Set.of((_polyline != null) ? [_polyline] : []),
        mapType: MapType.normal,

        initialCameraPosition: _kGooglePlex,
        // onCameraMove: (CameraPosition position) {
        //   _lastMapPosition = position.target;
        // },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          isMapCreate = true;
          // changeMapMode();
        },
      ),
    );
  }

  BitmapDescriptor meBmp;
  BitmapDescriptor kurirBmp;

  setBimap() async {
    meBmp = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.0, size: Size.fromWidth(100.0)
        ), 
        "assets/images/marker.png",);
  }

  // untuk realtime lokasi
  StreamSubscription<DocumentSnapshot> _getDataStrm;
  StreamSubscription<DocumentSnapshot> _strmLokasikurir;
  void getCurrentLocation() async {
    try {
      // var location = await _locationTracker.getLocation();
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      if (_getDataStrm != null) {
        _getDataStrm.cancel();
      }
      if (_strmLokasikurir != null) {
        _strmLokasikurir.cancel();
      }

      // _locationSubscription = _locationTracker.onLocationChanged.listen((LocationData currentLocation) async {
      //   if (_controller != null) {
      //     _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), tilt: 0.0, zoom: 15.0)));
      //     // _getPolyline(LatLng(currentLocation.latitude, currentLocation.longitude));
      //     _getPolyline(LatLng(currentLocation.latitude, currentLocation.longitude));
      //   }
      // });
      GeoPoint gp2 = widget.dataSn['latlong'];
      addmarker(LatLng(gp2.latitude, gp2.longitude), "poly");
      if (!mounted) return;
      _strmLokasikurir = Firestore.instance.collection("data_kurir_lokasi").document(widget.dataSn['id_kurir']).snapshots().listen((dtLokasiKurir) {
        if (dtLokasiKurir.exists) {
          GeoPoint gp = dtLokasiKurir.data['last_location'];
          if (_controller != null) {
            if (!mounted) return;
            setState(() {
              _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(target: LatLng(gp.latitude, gp.longitude), tilt: 10.0, zoom: 20.0)));
            });
            // _getPolyline(LatLng(gp2.latitude, gp2.longitude));
            _getPolyline(LatLng(gp.latitude, gp.longitude));
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        debugPrint("Permission Denied");
      }
    }
  }

  // untuk update marker
  addmarker(LatLng currentLocation, String id) {
    LatLng lt = LatLng(currentLocation.latitude, currentLocation.longitude);
    if (!mounted) return;
    setState(() {
      marker.removeWhere((element) {
        // print(element.markerId.value.toString());
        if (element.markerId.value.toString() == "me") {
          return true;
        } else {
          return false;
        }
      });
    });
    if (!mounted) return;
    setState(() => marker.add(Marker(
          markerId: MarkerId(id),
          position: lt,
          draggable: false,
          icon: (id == "me") ? meBmp : BitmapDescriptor.defaultMarker,
        )));
  }

  // untuk custom map
  // changeMapMode() {
  //   getJsonFile('assets/json/mapstyle.json').then(setMapStyle);
  // }

  void setMapStyle(String mapStyle) => _controller.setMapStyle(mapStyle);
  Future<String> getJsonFile(String path) async => await rootBundle.loadString(path);

  // untuk set poly
  _getPolyline(LatLng _orgnlocation) async {
    if (!mounted) return;
    // addmarker(LatLng(-5.147665, 119.43273), "poly");
    addmarker(LatLng(_orgnlocation.latitude, _orgnlocation.longitude), "me");

    PolylinePoints _polylinePoints = PolylinePoints();
    List<LatLng> _polylineCoordinates = [];
    GeoPoint gp2 = widget.dataSn['latlong'];

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates("AIzaSyAIBWT9Mi6oyT-X-zuB7P10364U2VMiPcg", PointLatLng(_orgnlocation.latitude, _orgnlocation.longitude), PointLatLng(gp2.latitude, gp2.longitude), travelMode: TravelMode.driving);
    // addmarker(LatLng(gp2.latitude, gp2.longitude), "poly");

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => _polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      _addPolyLine(_polylineCoordinates);
    }
  }

  _addPolyLine(List<LatLng> pl) {
    PolylineId id = PolylineId("poly");
    if (!mounted) return;
    setState(() {
      _polyline = Polyline(polylineId: id, color: CompanyColors.utama, points: pl);
    });
  }
}
