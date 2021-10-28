import 'package:flutter/material.dart';
import 'package:need_customer/profile/headerprofile/bgheaderprofile/bgheaderprofile.dart';
import 'package:need_customer/profile/headerprofile/profileutama/profileutama.dart';

class HeaderProfile extends StatefulWidget {
  HeaderProfile({Key key}) : super(key: key);

  @override
  _HeaderProfileState createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Colors.blue
      ),
      child: Stack(
        children: <Widget>[
          BgHeaderProfile(),
          ProfileUtama(),
        ],
      ),
    );
  }
}