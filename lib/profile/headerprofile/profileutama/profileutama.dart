import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class ProfileUtama extends StatefulWidget {
  ProfileUtama({Key key}) : super(key: key);

  @override
  _ProfileUtamaState createState() => _ProfileUtamaState();
}

class _ProfileUtamaState extends State<ProfileUtama> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged ,
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
            String nama = 'Guest';
            int point = 0;
            String urlPhoto;
            if (snapshot.connectionState==ConnectionState.active) {
              if (snapshot.hasData) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance.collection('data_customer').document(snapshot.data.uid).snapshots() ,
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot2){
                    if (snapshot2.connectionState==ConnectionState.active) {
                      if (snapshot2.data.exists) { 
                        nama = snapshot2.data.data['name']; 
                        urlPhoto = snapshot2.data.data['url_photo'];
                        point = snapshot2.data.data['point'];
                      }else{
                      }
                    }
                    return wdg(nama, point, urlPhoto);
                  },
                );
              }
            }
            return wdg(nama, point, urlPhoto);
          },
        ),
      ],
    );
  }

  Widget wdg(String nama, int point, String urlPhoto){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(color: Colors.black38.withOpacity(.3), blurRadius: 2.0)
        ]
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180.0,
            // color: Colors.red,
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                        color: CompanyColors.utama),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                        child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,),),
                      // child: Image.network('', fit: BoxFit.cover,),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120.0,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                        color: Colors.grey[200],
                        gradient: LinearGradient(
                          colors: [
                            CompanyColors.utama.withOpacity(.5),
                            CompanyColors.utama.withOpacity(.5),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter
                        )
                      ),
                      child: Center(
                        child: Image.asset('assets/logo/logo2.png'),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 70.0, width: 70.0,
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [BoxShadow(color: Colors.black38.withOpacity(.2), blurRadius: 2.0)]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child:(urlPhoto==null)?Image.asset('assets/images/user.png', fit: BoxFit.cover,): ShowImage(url: urlPhoto.toString()),
                          ),
                          // child: Image.network('', fit: BoxFit.cover,),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0, top: 9.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text('Selamat Datang', style: TextStyle(fontSize: 9.0),),
                              Padding(
                                padding: const EdgeInsets.only(top:3.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width-140,
                                  // color: Colors.red,
                                  child: Text(nama.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0),)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:6.0),
                                child: Text('Jumlah Point', style: TextStyle(fontSize: 9.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:3.0),
                                child: Text('$point Point', style: TextStyle(fontSize: 14.0),),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
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