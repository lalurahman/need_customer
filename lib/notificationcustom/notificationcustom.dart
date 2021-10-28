import 'package:flutter/material.dart';

class NotificationCustom extends StatefulWidget {
  NotificationCustom({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  _NotificationCustomState createState() => _NotificationCustomState();
}

class _NotificationCustomState extends State<NotificationCustom> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
  }
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    // if (message.containsKey('data')) {
    //   final dynamic data = message['data'];
    // }

    // if (message.containsKey('notification')) {
    //   final dynamic notification = message['notification'];
    // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}