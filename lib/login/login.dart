import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:need_customer/theme/companycolors.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading=false;

  @override
  void initState() { 
    super.initState();
    _googleSignIn.signOut();
    _auth.signOut();
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken(String uid) async {
    await _firebaseMessaging.getToken().then((deviceToken) async {
      print('Device Token : ${deviceToken.toString()}');
      await Firestore.instance.collection('notif_customer_public').document(deviceToken.toString()).get().then((fsNotif) async {
        if (fsNotif.exists) {
          print('sudah ada');
          await Firestore.instance.collection('notif_customer_public').document(deviceToken.toString()).updateData({
            'updated_at':DateTime.now(),
          });
        }else{
          print('belum ada');
          await Firestore.instance.collection('notif_customer_public').document(deviceToken.toString()).setData({
            'created_at':DateTime.now(),
            'updated_at':DateTime.now(),
          });
        }
      });
      await Firestore.instance.collection('notif_customer').document(uid).collection('list_token').document(deviceToken.toString()).get().then((fsNotif) async {
        if (fsNotif.exists) {
          print('sudah ada');
          await Firestore.instance.collection('notif_customer').document(uid).collection('list_token').document(deviceToken.toString()).updateData({
            'updated_at':DateTime.now(),
          });
        }else{
          print('belum ada');
          await Firestore.instance.collection('notif_customer').document(uid).collection('list_token').document(deviceToken.toString()).setData({
            'created_at':DateTime.now(),
            'updated_at':DateTime.now(),
          });
        }
      });
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    setState(() {
      loading=true;
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  void loginGoogle(){
    _handleSignIn()
    .then((FirebaseUser user) async {
      if (user==null) {
        return;
      }
      Map<String, dynamic> dataS = {
        'name':user.displayName,
        'email':user.email,
        'url_photo':user.photoUrl,
      };
      Map<String, dynamic> dataS2 = {
        'name':user.displayName,
        'email':user.email,
        'url_photo':user.photoUrl,
        'saldo':0,
        'point':3,
      };
      // Map<String, dynamic> dataS3 = {
      //   'name':user.displayName,
      //   'email':user.email,
      //   'url_photo':user.photoUrl,
      // };
      await Firestore.instance.collection('data_customer').document(user.uid).get().then((onValue) async {
        if (onValue.exists) {    
          // await Firestore.instance.collection('data_customer').document(user.uid).updateData(dataS3);        
        } else {
          await Firestore.instance.collection('data_customer').document(user.uid).setData(dataS2);        
        }
        await Firestore.instance.collection('users').document(user.uid).setData(dataS);        
        await _getToken(user.uid);
        Navigator.pop(context);
        setState(() {
          loading=false;
        });
      });
    })
    .catchError((e) {
      setState(() {
        loading=false;
      });
      print(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/pattern.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: CompanyColors.utama.withOpacity(.9)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/logo/logo2.png', width: 100.0,),
                Padding(
                  padding: const EdgeInsets.only(top:20.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text('Selamat Datang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
                      Text('Silahkan Login Disini', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: loginGoogle,
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/googleloginlogo.png'),
                        Text('  Login'),
                        Text(' Google', style: TextStyle(fontWeight: FontWeight.w800),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          (!loading)?Container():
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: CompanyColors.utama.withOpacity(.7)),
            // child: Center(child: Text('Loading...', style: TextStyle(fontWeight: FontWeight.w800),)),
          ),
          (!loading)?Container():
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Image.asset('assets/images/loading.gif', width: MediaQuery.of(context).size.width-300),
            ),
          ),
        ],
      ),
    );
  }
}
