import 'package:flutter/material.dart';
import 'package:need_customer/newhome/berita/berita.dart';
import 'package:need_customer/newhome/header/header.dart';
import 'package:need_customer/newhome/menuhome/menuhome.dart';
import 'package:need_customer/newhome/transaksiselesai/transaksihome.dart';
import 'package:need_customer/newhome/youtubeneed/youtubeneed.dart';

class NewHome extends StatefulWidget {
  NewHome({Key key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // SliverAppBar(
          //   centerTitle: true,
          //   floating: true,
          //   expandedHeight: 300.0,
          //   forceElevated: true,
          //   stretch: true,
          //   snap: true,
          //   pinned: true,
          //   flexibleSpace: const FlexibleSpaceBar(
          //     title: const Text('_SliverAppBar')
          //   ),
          // ),
          SliverList(
            delegate: SliverChildListDelegate([
              Header(),
              TransaksiHome(),
              MenuHome(),
              YoutubeNeed(),
              Container(width: MediaQuery.of(context).size.width, height: 5.0, color: Colors.grey[200],),
              Berita(),
            ]),
          )
        ],
      ),
    );
  }
}
