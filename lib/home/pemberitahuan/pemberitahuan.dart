import 'package:flutter/material.dart';

class Pemberitahuan extends StatefulWidget {
  @override
  _PemberitahuanState createState() => _PemberitahuanState();
}

class _PemberitahuanState extends State<Pemberitahuan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30.0,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(color: Colors.grey),
          BoxShadow(color: Colors.grey),
        ]
      ),
      child: Center(
        child: Text('Selamat Datang Denis', style: TextStyle(color: Colors.white),)
      ),
    );
  }
}