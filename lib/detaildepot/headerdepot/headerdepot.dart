import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/class/terkaituser.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderDepot extends StatefulWidget {
  HeaderDepot({Key key, @required this.id}) : super(key: key);
  final String id;
  @override
  _HeaderDepotState createState() => _HeaderDepotState();
}

class _HeaderDepotState extends State<HeaderDepot> {
  bool loadingWishlist = false;
  bool stsWishlist = false;
  @override
  void initState() { 
    getWishlist();
    super.initState();
  }

  getWishlist() async {
    setState(() {
      loadingWishlist=true;
    });
    await TerkaitUser(idDepot: widget.id, context: context, showPeringatan: false).getWishlist.then((onValue){
      setState(() {
        stsWishlist=onValue;
        loadingWishlist=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('data_mitra').document(widget.id).snapshots() ,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        String fotoDepot;
        GeoPoint latlong;
        if (snapshot.connectionState==ConnectionState.active) {
          if (snapshot.data.exists) {
            fotoDepot=snapshot.data.data['foto_depot'];
            latlong=snapshot.data.data['latlong'];
          }
        }
        return headernya(fotoDepot, latlong);
      },
    );
  }

  Widget headernya(String fotoDepot, GeoPoint latlong){
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.black.withOpacity(.1)),
          child: (fotoDepot==null)?Container():
            ShowImage(url: fotoDepot,)
        ),
        Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.black.withOpacity(.3)),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: .0, right: .0, top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:15.0, right: 15.0,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 35.0, width: 35.0,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(.3), borderRadius: BorderRadius.circular(100.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right:4.0),
                                child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.0,),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () async {
                            if (!loadingWishlist) {
                              setState(()=>loadingWishlist = true);
                              await TerkaitUser(idDepot: widget.id, context: context).setWishlist.then((onValue){
                                getWishlist();
                                setState(()=>loadingWishlist = true);
                              });
                            }
                          },
                          child: Container(
                            height: 35.0, width: 35.0,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(.3), borderRadius: BorderRadius.circular(100.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right:.0),
                                child: (loadingWishlist)?Text('...', style: TextStyle(color: Colors.white),):
                                Icon(Icons.favorite, color: (stsWishlist)?Colors.red:Colors.white, size: 18.0,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: (){
                            // GeoPoint latlong = widget.dataTransaksiState['latlong'];
                            if (latlong!=null) {
                              openMap(latlong.latitude, latlong.longitude).then((onValue){});
                            }
                          },
                          child: Container(
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Image.asset('assets/images/googlemapsicon.png', width: 70.0,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
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