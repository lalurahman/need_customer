import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class LoadingList extends StatefulWidget {
  LoadingList({Key key}) : super(key: key);

  @override
  _LoadingListState createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/images/pattern.jpg', fit: BoxFit.cover,),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: CompanyColors.utama.withOpacity(.9),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Image.asset('assets/images/loading.gif', width: MediaQuery.of(context).size.width-300),
          ),
        ),
      ],
    );
  }
}