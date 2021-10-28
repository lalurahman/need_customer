import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  CustomLoading({Key key}) : super(key: key);

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom:10.0),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 2.0)
            ]
          ),
          child: Text('Loading', style: TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.w600),)),
      ),
    );
  }
}