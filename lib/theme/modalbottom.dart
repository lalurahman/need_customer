import 'package:flutter/material.dart';

class ModalBottom {
  mainBottomSheet(BuildContext context, Widget wdg){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context){
        return wdg;
      }
    );
  }
}