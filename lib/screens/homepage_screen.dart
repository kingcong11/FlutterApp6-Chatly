/* Packages */
import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/* Widgets */
import '../widgets/favorites_section.dart';

class HomePageScreen extends StatelessWidget {
  /* Properties */
  static const routeName = '/homepage';

  final double contentHeight;
  final double contentWidth;

  HomePageScreen({
    @required this.contentHeight,
    @required this.contentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: contentHeight,
      width: contentWidth,
      color: Theme.of(context).primaryColor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: contentHeight * .23,
              // color: Colors.lightBlue,
              padding: const EdgeInsets.only(
                top: 14.0,
              ),
              child: FavoritesSection(),
            ),
            Expanded(
              child: Container(
                // color: Colors.lightBlue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
