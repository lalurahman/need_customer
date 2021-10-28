import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadImageCustom extends StatefulWidget {
  UploadImageCustom({Key key, @required this.image, this.urlImage, @required this.imageGet, @required this.subtitle, @required this.title}) : super(key: key);
  final String title, subtitle, urlImage;
  final File image;
  final Function imageGet;
  @override
  _UploadImageCustomState createState() => _UploadImageCustomState();
}

class _UploadImageCustomState extends State<UploadImageCustom> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.title),
        Text(widget.subtitle, style: TextStyle(color: Colors.grey, fontSize: 12.0),),
        Container(
          margin: EdgeInsets.only(bottom: 15.0, top: 10.0),
          child: GestureDetector(
            onTap: widget.imageGet,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: (widget.urlImage!=null)?Image.network(widget.urlImage, fit: BoxFit.cover,):(widget.image!=null)?
                    Image.file(widget.image, fit: BoxFit.cover,):
                    Center(child: Text(widget.title.toString())),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}