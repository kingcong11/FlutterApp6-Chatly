import 'dart:async';
import 'dart:io';

/* Packages */
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttericon/entypo_icons.dart';

/* Helpers */
import 'package:chatly/helpers/database.dart';

class ProfileImageInput extends StatefulWidget {
  const ProfileImageInput({
    Key key,
    @required this.deviceSize,
    @required this.ctxWithScaffold,
  }) : super(key: key);

  final Size deviceSize;
  final BuildContext ctxWithScaffold;

  @override
  _ProfileImageInputState createState() => _ProfileImageInputState();
}

class _ProfileImageInputState extends State<ProfileImageInput>
    with TickerProviderStateMixin {
  /* Properties */
  var db = new DatabaseHelper();
  File _storedImage;
  File _storedImageHolder;
  var _isUploading = false;
  AnimationController _expandAnimationController;
  Animation<Size> _heightExpandAnimation;
  AnimationController _fadeAnimationController;
  Animation<double> _opacityAnimation;

  /* Methods */
  Future<String> showOptions() async {
    try {
      var option = await showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('Choose from Photos'),
              onPressed: () {
                Navigator.of(context).pop('gallery');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Use Camera'),
              onPressed: () {
                Navigator.of(context).pop('camera');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
      return option;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> takePicture({bool fromCamera}) async {
    try {
      final picker = ImagePicker();
      PickedFile imageFile = await picker.getImage(
        source: (fromCamera) ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 600,
        maxWidth: 600,
        imageQuality: 75,
      );

      if (imageFile != null) {
        _expandAnimationController.forward().whenComplete(() {
          setState(() {
            _storedImage = File(imageFile.path);
          });
          _fadeAnimationController.forward();
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    /* height expand animation */
    // set up animation controller
    _expandAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 400),
    );

    _heightExpandAnimation = Tween<Size>(
      begin: Size(100, 100),
      end: Size(165, 150),
    ).animate(CurvedAnimation(
      parent: _expandAnimationController,
      curve: Curves.easeIn,
    ));

    /* opacity animation */
    // set up animation controller
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _expandAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _heightExpandAnimation,
          builder: (ctx, staticChild) => Container(
            height: _heightExpandAnimation.value.height,
            child: staticChild,
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                overflow: Overflow.visible,
                children: [
                  AnimatedCrossFade(
                    crossFadeState: (_storedImage == null)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 500),
                    firstChild: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: FutureBuilder(
                          future: db.getCurrentUserInfo(),
                          builder: (_, futureSnapshot) {
                            if (futureSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Image.asset('assets/images/no-user.png');
                            } else {
                              final _userCredentials =
                                  futureSnapshot.data as Map<String, dynamic>;

                              if (_userCredentials.containsKey('profileImageUrl')) {
                                return Image.network(_userCredentials['profileImageUrl'], fit: BoxFit.cover,);
                              } else {
                                return Image.asset('assets/images/no-user.png');
                              }
                            }
                          },
                        ),
                      ),
                    ),

                    /*
                      for the second child I need to check if the storedImage is currently null because
                      AnimatedCrossFade assumes that the first or second child is already loaded and did not depend
                      on state changes, if I did not check this, it will cause error because _storedImage is currently
                      null, as i've said AnimatedCrossFade assumes that either of the child is constant thats why Image.file
                      fails because it tries to load a null file 
                    */

                    secondChild: (_storedImage == null)
                        ? Container()
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child:
                                  Image.file(_storedImage, fit: BoxFit.cover),
                            ),
                          ),
                  ),
                  GestureDetector(
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () async {
                      var optionSelected = await showOptions();

                      if (optionSelected == 'camera') {
                        takePicture(fromCamera: true);
                      } else if (optionSelected == 'gallery') {
                        takePicture(fromCamera: false);
                      } else {
                        return;
                      }
                    },
                  ),
                ],
              ),
              if (_storedImage != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Entypo.cancel,
                                color: Colors.deepOrange,
                                size: 25.0,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _fadeAnimationController.reverse();

                          _expandAnimationController.reverse();

                          _storedImage = null;
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    Builder(
                      builder: (ctx) => GestureDetector(
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  EvaIcons.cloudUploadOutline,
                                  color: Colors.blue,
                                  size: 25.0,
                                ),
                                Text(
                                  'Upload',
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            _fadeAnimationController.reverse();
                            _expandAnimationController
                                .reverse()
                                .whenComplete(() {
                              setState(() {
                                _isUploading = true;
                              });
                            });
                            _storedImageHolder = _storedImage;
                            _storedImage = null;
                          });
                          try {
                            await db.uploadProfilePicture(_storedImageHolder);
                          } catch (e) {
                            Navigator.of(context).pop();
                            Scaffold.of(widget.ctxWithScaffold)
                                .showSnackBar(SnackBar(
                              content: Text(
                                  'Something went wrong, please try again later.'),
                              backgroundColor: Colors.red,
                            ));
                            print(e);
                          } finally {
                            setState(() {
                              _isUploading = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (_isUploading)
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[800].withOpacity(.4),
            ),
            child: SpinKitFadingCircle(
              color: Colors.white,
              size: 45,
            ),
          ),
      ],
    );
  }
}
