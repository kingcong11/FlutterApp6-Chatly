/* Packages */
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

/* Providers */
import '../providers/authentication_service_provider.dart';

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
  // var _isDrawerOpen = false;
  // double _customDrawerYOffset;

  /* Builders */
  Widget _appbarBuilder(Size deviceSize) {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: AssetImage('assets/images/user.jpg'),
          ),
          onTap: () => _showProfileActions(),
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
        IconButton(
          icon: Icon(
            MdiIcons.feather,
            size: 30,
          ),
          onPressed: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app_outlined),
          onPressed: () {
            Provider.of<AuthenticationService>(context, listen: false)
                .signOut();
            // context.read<AuthenticationService>().signOut();
          },
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
  _showProfileActions() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ProfileBottomSheet();
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
    // switch (_isDrawerOpen) {
    //   case true:
    //     _customDrawerYOffset = 150;

    //     break;
    //   case false:
    //     _customDrawerYOffset = 500;

    //     break;
    // }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar,
        body: SafeArea(
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
      ),
    );

    // Stack(
    //   children: [
    //     AnimatedContainer(
    //       // animate this with fadedTransition instead
    //       duration: Duration(milliseconds: 300),
    //       decoration: BoxDecoration(color: Colors.grey[900].withOpacity(0.7)),
    //       child: Container(
    //         width: deviceSize.width,
    //         height: deviceSize.height,
    //         transform: Matrix4.translationValues(0, _customDrawerYOffset, 1),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(25),
    //             topRight: Radius.circular(25),
    //           ),
    //         ),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(25),
    //             topRight: Radius.circular(25),
    //           ),
    //           child: Scaffold(
    //             body: Text('something'),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
