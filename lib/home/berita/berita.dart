import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/models/listberita.dart';
import 'package:need_customer/theme/companycolors.dart';

class Berita extends StatefulWidget {
  @override
  _BeritaState createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {

  List<ListBerita> berita = [];

  @override
  void initState() { 
    super.initState();
    getData();
  }
  getData(){
    Firestore.instance.collection('berita').orderBy('created_at', descending: true).snapshots().listen((onData){
      if(!mounted) return;
      if (onData.documents.length>0) {
        setState(() {
          berita = onData.documents.map((f){
            Timestamp tm = f.data['created_at'];
            DateTime dt = tm.toDate();
            return ListBerita(id: f.documentID, judul: f.data['judul'], tgl: '${dt.day}-${dt.month}-${dt.year}', urlphoto: f.data['url_photo']);
          }).toList();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: (berita.length==0)?Container():GridView.count(
        childAspectRatio: 1.0,
        crossAxisCount: 2,
        // crossAxisSpacing: 18.0,
        padding: EdgeInsets.only(top: 5.0, left: 10.0, right:10.0),
        mainAxisSpacing: 18.0,
        children: berita.map((f){
          return cardnya(f.id, f.judul, f.tgl, f.urlphoto);
        }).toList() 
      )
    );
  }

  Widget cardnya(String url, String judul, String tgl, String urlPhoto){
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5.0)
          ],
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: ShowImage(url: urlPhoto.toString())
              ),
            ),
            Column(
              children: <Widget>[
                Expanded(child: Container()),
                Container(
                  // height: 70,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(judul, style: TextStyle(fontSize: 13.0, color: CompanyColors.utama, fontWeight: FontWeight.w600),),
                      Padding(
                        padding: const EdgeInsets.only(top:3.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range, size: 12.0, color: Colors.grey,),
                            Text(' ${tgl.toString()}', style: TextStyle(fontSize: 10.0, color: Colors.grey),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
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