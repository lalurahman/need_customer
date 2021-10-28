// import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:need_customer/firebasemessagingwdg/firebasemessagingwdg.dart';
import 'package:need_customer/listpromo/listpromo.dart';
import 'package:need_customer/newhome/newhome.dart';
import 'package:need_customer/profile/profile.dart';
import 'package:need_customer/theme/companycolors.dart';
import 'package:need_customer/transaksiku/transaksiku.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'dart:async';

class HomeBegin extends StatefulWidget {
  HomeBegin({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeBeginState createState() => _HomeBeginState();
}

class _HomeBeginState extends State<HomeBegin> {
  // PersistentTabController _controller;
  @override
  void initState() {
    super.initState();
  }
  // @override
  // void initState() { 
  //   super.initState();
  //   _controller = PersistentTabController(initialIndex: 0);
  // }
  // List<PersistentBottomNavBarItem> _navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //         icon: Icon(CupertinoIcons.home),
  //         title: ("Home"),
  //         activeColor: CompanyColors.utama,
  //         inactiveColor: CupertinoColors.systemGrey,
  //     ),
  //     PersistentBottomNavBarItem(
  //         icon: Icon(Icons.list),
  //         title: ("Transaksi"),
  //         activeColor: CompanyColors.utama,
  //         inactiveColor: CupertinoColors.systemGrey,
  //     ),
  //     PersistentBottomNavBarItem(
  //         icon: Icon(CupertinoIcons.tag_solid),
  //         title: ("Promo"),
  //         activeColor: CompanyColors.utama,
  //         inactiveColor: CupertinoColors.systemGrey,
  //     ),
  //     PersistentBottomNavBarItem(
  //         icon: Icon(Icons.person),
  //         title: ("Profil"),
  //         activeColor: CompanyColors.utama,
  //         inactiveColor: CupertinoColors.systemGrey,
  //     ),
  //   ];
  // }

  // List<Widget> _buildScreens() {
  //   return [
  //     NewHome(),
  //     TransaksiKu(),
  //     ListPromo(),
  //     Profile(),
  //   ];
  // }

  int currentindex = 0;  
  List<Widget> listW = [
    NewHome(),
    TransaksiKu(),
    ListPromo(),
    Profile(),
  ];
  Color clr = CompanyColors.utama;

  @override
  Widget build(BuildContext context) {
    return FirebaseMessagingWdg(
      child: Scaffold(
        backgroundColor: Colors.white,
        // bottomNavigationBar: PersistentTabView(
        //   controller: _controller,
        //   items: _navBarsItems(),
        //   screens: _buildScreens(),
        //   showElevation: true,
        //   navBarCurve: NavBarCurve.upperCorners,
        //   confineInSafeArea: true,
        //   handleAndroidBackButtonPress: true,
        //   iconSize: 26.0,
        //   navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property
        //   onItemSelected: (index) {
        //     print(index);
        //   },
        // ),
        // bottomNavigationBar: FancyBottomNavigation(
        //   circleColor: CompanyColors.utama,
        //   inactiveIconColor: CompanyColors.utama,
        //   tabs: [
        //     TabData(iconData: Icons.home, title: "Home"),
        //     TabData(iconData: Icons.list, title: "Transaksi"),
        //     TabData(iconData: Icons.redeem, title: "Promo"),
        //     TabData(iconData: Icons.perm_identity, title: "Profile"),
        //   ],
        //   onTabChangedListener: (position) {
        //     setState(() {
        //       currentindex = position;
        //       // clr = (currentindex==0)?CompanyColors.utama:(currentindex==1)?Colors.white:(currentindex==2)?Colors.green:Colors.purple;
        //     });
        //   },
        // ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: CompanyColors.utama.withOpacity(0.4),
          index: currentindex,
          animationDuration: Duration(milliseconds: 100),
          animationCurve: Curves.bounceInOut,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, color: CompanyColors.utama,),
            Icon(Icons.list, color: CompanyColors.utama,),
            Icon(Icons.redeem, color: CompanyColors.utama,),
            Icon(Icons.perm_identity, color: CompanyColors.utama,),
          ],
          onTap: (index) {
            setState(() {
              currentindex = index;
            });
          },
        ),
        body: listW[currentindex],
      ),
    );
  }
}
