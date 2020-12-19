/* Packages */
import '../../providers/authentication_service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

/* Helpers */
import 'package:chatly/helpers/database.dart';

/* Widgets */
import './profile_image_input.dart';

class ProfileBottomSheet extends StatefulWidget {
  /* Properties */

  const ProfileBottomSheet({Key key, @required this.contextWithScaffold})
      : super(key: key);

  final BuildContext contextWithScaffold;

  @override
  _ProfileBottomSheetState createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  // var _isUploading = false;

  /* Methods */
  // void _toggleLoadingState() {
  //   setState(() {
  //     _isUploading = !_isUploading;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    /* Properties */
    var db = DatabaseHelper();
    final deviceSize = MediaQuery.of(context).size;
    var hasProfimeImage = false;

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
            final userInfo = futureSnapshot.data as Map<String, dynamic>;
            if(userInfo.containsKey('profileImageUrl')){
              hasProfimeImage = true;
            }

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
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                ProfileImageInput(deviceSize: deviceSize, ctxWithScaffold: widget.contextWithScaffold),
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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.teal],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.exit_to_app_outlined,
                            size: 27,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      Provider.of<AuthenticationService>(context, listen: false)
                          .signOut();
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
