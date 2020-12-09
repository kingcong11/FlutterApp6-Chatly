/* Packages */
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Screens */
import './homepage_screen.dart';
import './online_screen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  /* Builders */
  Widget _appbarBuilder() {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: AssetImage('assets/images/user.jpg'),
        ),
      ),
      title: Text(
        'Chats',
        style: TextStyle(fontSize: 24),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            MdiIcons.feather,
            size: 30,
          ),
          onPressed: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ],
      bottom: TabBar(
        labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 16.0),
        indicatorColor: Color(0xFFe71d35),
        tabs: [
          Tab(text: 'Messages'),
          Tab(text: 'Online'),
        ],
        onTap: (index) {
          print(index);
        },
      ),
      elevation: 0,
    );
  }

  /* Getters */
  double _computeMainContentHeight(
      MediaQueryData mediaQueryData, AppBar appbar) {
    return mediaQueryData.size.height -
        (appbar.preferredSize.height + mediaQueryData.padding.top);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appbar = _appbarBuilder();
    final mainContentHeigt = _computeMainContentHeight(mediaQuery, appbar);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar,
        body: SafeArea(
          child: TabBarView(
            children: [
              HomePageScreen(
                contentHeight: mainContentHeigt,
                contentWidth: mediaQuery.size.width,
              ),
              OnlineScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
