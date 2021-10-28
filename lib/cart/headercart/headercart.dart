import 'package:flutter/material.dart';
import 'package:need_customer/theme/companycolors.dart';

class HeaderCart extends StatelessWidget implements PreferredSizeWidget {
  // final String title;  
  // final Widget child;  
  // final Function onPressed;  
  // final Function onTitleTapped;  
 
  @override 
  final Size preferredSize;   
  HeaderCart() : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top:30.0),
      decoration: BoxDecoration(
        color: CompanyColors.utama,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Icon(Icons.arrow_back_ios, color: Colors.white,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
