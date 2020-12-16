/* Packages */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

/* Helpers */
import 'package:chatly/helpers/database.dart';

/* Widgets */
import './profile_image_input.dart';

class ProfileBottomSheet extends StatelessWidget {
  /* Properties */
  // File storedImage;

  const ProfileBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* Properties */
    var db = DatabaseHelper();
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      height: deviceSize.height * 0.8,
      width: deviceSize.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: FutureBuilder(
        future: db.getCurrentUserInfo(),
        builder: (_, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return PKCardProfileSkeleton(
              isCircularImage: true,
              isBottomLinesActive: true,
            );
          } else {
            final userInfo = futureSnapshot.data;
            // print(userInfo);

            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 0.5,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                ProfileImageInput(),
                SizedBox(height: 10),
                Text(
                  userInfo['username'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  userInfo['email'],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
