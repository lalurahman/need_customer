import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BerikanRating extends StatefulWidget {
  BerikanRating({Key key}) : super(key: key);

  @override
  _BerikanRatingState createState() => _BerikanRatingState();
}

class _BerikanRatingState extends State<BerikanRating> {
  double rt=1.0;
  String idUser;
  bool loading = false;
  @override
  void initState() { 
    super.initState();
    getUser();
  }
  getUser() async {
    await FirebaseAuth.instance.currentUser().then((onValue) async {
      if (onValue.uid!=null) {
        setState(() {
          idUser=onValue.uid;
        });
        await Firestore.instance.collection('data_customer').document(onValue.uid).get().then((onValue2){
          if (onValue2.exists) {
            // print('sadasd');
            setState(() {
              rt = (onValue2.data['rating_need']!=null)?(onValue2.data['rating_need']+.0):1.0;
            });
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );    
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.padding+10,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                'Berikan Kami Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              RatingBar(
                initialRating: rt,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rt=rating+.0;
                  });
                },
              ),
              SizedBox(height: 24.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    color: Colors.red,
                    child: Text('BATAL', style: TextStyle(color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: FlatButton(
                      onPressed: () async {
                        if(idUser!=null && loading==false)
                        setState(() {
                          loading=true;
                        });
                        await Firestore.instance.collection('data_customer').document(idUser).updateData({
                          'rating_need':rt, 'updated_at':DateTime.now()
                        }).then((onValue){
                          setState(() {
                            loading=false;
                          });
                          // AwesomeDialog(
                          //   context: context,
                          //   dismissOnTouchOutside: false,
                          //   animType: AnimType.SCALE,
                          //   dialogType: DialogType.SUCCES,
                          //   tittle: 'INFO',
                          //   desc:   'Terimakasih Telah Memberikan Rating',
                          //   btnOkText: 'OK',
                          //   btnOkOnPress: (){
                            Navigator.of(context).pop();
                          //     // Navigator.of(context).pop();
                          //   }
                          // ).show();
                        });
                      },
                      color: Colors.green,
                      child: Text((loading)?'Loading..':'KIRIM', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}