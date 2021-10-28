import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class MyLocation extends StatefulWidget {
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  String alamat = 'Jakarta';

  @override
  void initState() {
    super.initState();
    getAlamat();
  }

  getAlamat() async {
    Address first;
    List<Address> ad;
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    ad = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = ad.first;
    setState(() {
      alamat = first.addressLine;
    });
    print("${first.featureName} : ${first.addressLine}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0, right: 20.0, left:20.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              print(position);
            },
            child: Icon(Icons.location_on, color: Colors.grey[800],)),
          Container(
            width: MediaQuery.of(context).size.width-100,
            // decoration: BoxDecoration(color: Colors.green),
            child: Text('  ${alamat.toString()}', overflow: TextOverflow.ellipsis,  style: TextStyle(color: Colors.grey[800]),))
        ],
      ),
    );
  }
}