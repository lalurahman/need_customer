import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BeritaAfiliasi extends StatefulWidget {
  BeritaAfiliasi({Key key}) : super(key: key);

  @override
  _BeritaAfiliasiState createState() => _BeritaAfiliasiState();
}

class _BeritaAfiliasiState extends State<BeritaAfiliasi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 15.0, right: .0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Berita Afiliasi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('berita_afiliasi').snapshots() ,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.connectionState==ConnectionState.active) {
                  if (snapshot.data.documents.length>0) {
                    return Column(
                      children: snapshot.data.documents.map((f){
                        return wdg(f.data['url_photo']);
                      }).toList(),
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget wdg(String urlFoto){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          // width: 100.0,
          width: MediaQuery.of(context).size.width-30.0,
          height: 200.0,
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: ShowImage(url: urlFoto.toString())),
            // child: Image.network(urlFoto.toString()),),
        ),
        // Container(
        //   margin: EdgeInsets.only(left: 10.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Container(
        //         padding: const EdgeInsets.only(bottom:5.0),
        //         width: MediaQuery.of(context).size.width-150,
        //         child: Text(judul.toString(), style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 1),
        //       ),
        //       Container(
        //         width: MediaQuery.of(context).size.width-150,
        //         child: Text(isi.toString(), style: TextStyle(fontSize: 11.0, height: 1.5), overflow: TextOverflow.ellipsis, maxLines: 3,)),
        //       Container(
        //         margin: EdgeInsets.only(top: 5.0),
        //         child: Text('Detail', style: TextStyle(color: Colors.blue),),
        //       )
        //     ],
        //   ),
        // ),
      ],
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