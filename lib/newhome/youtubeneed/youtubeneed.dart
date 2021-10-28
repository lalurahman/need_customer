import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeNeed extends StatefulWidget {
  YoutubeNeed({Key key}) : super(key: key);

  @override
  _YoutubeNeedState createState() => _YoutubeNeedState();
}

class _YoutubeNeedState extends State<YoutubeNeed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Video', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('video_need').snapshots() ,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (snapshot.connectionState==ConnectionState.active) {
                    if (snapshot.data.documents.length>0) {
                      return Row(
                        children: snapshot.data.documents.map((f){
                          return wdg(f.data['url'].toString(), f.data['judul'].toString(), f.data['thumbnail'].toString());
                        }).toList(),
                      );
                    }
                  }
                  return Row(children: <Widget>[wdgKosong(),]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wdg(String url, String judul, String thumbnail){
    return GestureDetector(
      onTap: (){
        launchURL(url);
      },
      child: Container(
        color: Colors.white.withOpacity(.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Text(judul.toString(), style: TextStyle(fontSize: 13.0),),
            ),
            Container(
              width: 220.0,
              height: 120.0,
              margin: EdgeInsets.only(bottom: .0, right: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 220.0,
                    height: 120.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: ShowImage(url: thumbnail.toString()))),
                      // child: Image.network(thumbnail.toString(), fit: BoxFit.cover,))),
                  Container(
                    width: 220.0,
                    height: 120.0,
                    // color: Colors.white.withOpacity(.1),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Center(
                        child: Icon(Icons.play_circle_filled, color: Colors.white, size: 45.0,),
                      )
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wdgKosong(){
    return GestureDetector(
      onTap: (){
        // launchURL(url);
      },
      child: Container(
        color: Colors.white.withOpacity(.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Text('Need Indonesia', style: TextStyle(fontSize: 13.0),),
            ),
            Container(
              width: MediaQuery.of(context).size.width-80,
              height: 100.0,
              margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0)
              ),
            ),
          ],
        ),
      ),
    );
  }

  launchURL(String urlnya) async {
    if (Platform.isIOS) {
      // if (await canLaunch('youtube://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw')) {
      //   await launch('youtube://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw', forceSafariVC: false);
      // } else {
      //   if (await canLaunch('https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw')) {
      //     await launch('https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw');
      //   } else {
      //     throw 'Could not launch https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
      //   }
      // }
    } else {
      String url = urlnya;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
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