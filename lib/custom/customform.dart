import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomForm extends StatefulWidget {
  CustomForm({Key key, this.enabled, @required this.title, this.ctRight, @required this.maxLength, this.onChange, @required this.subtitle, @required this.ctr,
    this.justNumber=false
  }) : super(key: key);
  final String title, subtitle;
  final TextEditingController ctr;
  final int maxLength;
  final bool enabled;
  final Function onChange;
  final bool justNumber;
  final Widget ctRight;
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: .0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.title),
                  Text(widget.subtitle, style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                ],
              ),
              Expanded(child: Container()),
              (widget.ctRight==null)?Container():widget.ctRight,
            ],
          ),
          Container(
            margin: EdgeInsets.only(top:10.0),
            child: TextField(
              enabled: (widget.enabled==null)?true:widget.enabled,
              onChanged: widget.onChange,
              controller: widget.ctr,
              maxLength: widget.maxLength,
              style: TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                hintText: widget.subtitle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                contentPadding: EdgeInsets.only(left:15.0, right: 15.0, top: 0.0, bottom: 0.0),
                fillColor: Colors.grey[100],
                filled: true,
              ),
              keyboardType: (widget.justNumber)?TextInputType.number:TextInputType.text,
              inputFormatters: (widget.justNumber)?<TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ]:<TextInputFormatter>[],
            ),
          ),
        ],
      ),
    );
  }
}