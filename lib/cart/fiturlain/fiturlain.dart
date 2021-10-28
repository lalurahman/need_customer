import 'package:flutter/material.dart';
import 'package:need_customer/cart/fiturlain/jemputantar/jemputantar.dart';
import 'package:need_customer/cart/fiturlain/tingkatantar/tingkatantar.dart';

class FiturLain extends StatefulWidget {
  FiturLain({Key key, @required this.idDepot, @required this.idUser}) : super(key: key);
  final String idDepot, idUser;
  @override
  _FiturLainState createState() => _FiturLainState();
}

class _FiturLainState extends State<FiturLain> {
  bool show = false;
  @override
  void initState() {
    super.initState();
    show = false;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            setState(() {
              show=(!show)?true:false;
            });
          },
          child: Container(
            color: Colors.white.withOpacity(.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Fitur Lain', style: TextStyle(fontWeight: FontWeight.w600),),
                      (show)?Container():Text('Fitur Lain Yang Bisa Anda Gunakan', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 11),),
                    ],
                  ),
                  Expanded(child: Container()),
                  Icon((show)?Icons.arrow_drop_up:Icons.arrow_drop_down_circle, color: Colors.cyan[300], size: 30.0,)
                ],
              ),
            ),
          ),
        ),
        (!show)?Divider():
        Column(
          children: <Widget>[
            TingkatAntar(idDepot: widget.idDepot, idUser: widget.idUser,),
            JemputAntar(idDepot: widget.idDepot, idUser: widget.idUser,),
          ],
        ),
      ],
    );
  }
}