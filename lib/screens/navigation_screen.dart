import 'dart:io';
/* Packages */
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/* Helpers */
import 'package:chatly/helpers/database.dart';

/* Screens */
import './homepage_screen.dart';
import './online_screen.dart';
import './search_screen.dart';

/* Widgets */
import '../widgets/shared/profile_modal_bottom_sheet.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  /* Properties */
  var db = new DatabaseHelper();

  /* Builders */
  Widget _appbarBuilder(Size deviceSize) {
    return AppBar(
      leading: Builder(
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            child: FutureBuilder(
              future: db.getCurrentUserInfo(),
              builder: (_, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  var _userCredentials = futureSnapshot.data as Map<String, dynamic>;
                  // print(_userCredentials);

                  return CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: (_userCredentials.containsKey('profileImageUrl')) ? NetworkImage(_userCredentials['profileImageUrl']) : AssetImage('assets/images/no-user.png'),
                  );
                }
              },
            ),
            onTap: () => _showProfileActions(ctx),
          ),
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
            Icons.search,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SearchScreen(),
            ));
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        Builder(
          builder: (ctx1) => IconButton(
            icon: Icon(
              MdiIcons.feather,
              size: 30,
            ),
            onPressed: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ],
      bottom: TabBar(
        labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 16.0),
        indicatorColor: Color(0xFFf6aa48).withOpacity(.99),
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

  /* Methods */
  _showProfileActions(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ProfileBottomSheet(contextWithScaffold: ctx);
      },
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
    final deviceSize = mediaQuery.size;
    final appbar = _appbarBuilder(deviceSize);
    final mainContentHeigt = _computeMainContentHeight(mediaQuery, appbar);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar,
        body: ConnectivityWidget(
          builder: (_, isOnline) => SafeArea(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomePageScreen(
                  contentHeight: mainContentHeigt,
                  contentWidth: mediaQuery.size.width,
                ),
                OnlineScreen(),
              ],
            ),
          ),
          offlineBanner: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 38,
            padding: const EdgeInsets.all(5),
            color: Colors.red,
            child: Text(
              'Please check your internet connection',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
