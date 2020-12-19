import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FavoritesSection extends StatefulWidget {
  @override
  _FavoritesSectionState createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends State<FavoritesSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  MdiIcons.dotsHorizontal,
                  size: 25,
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: 15,
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/no-user.png'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 75,
                        alignment: Alignment.center,
                        child: Text(
                          'user.name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
