import 'dart:io';

/* Packages */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageInput extends StatefulWidget {
  const ProfileImageInput({
    Key key,
  }) : super(key: key);

  @override
  _ProfileImageInputState createState() => _ProfileImageInputState();
}

class _ProfileImageInputState extends State<ProfileImageInput> {
  /* Properties */
  File _storedImage;

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
        // maxHeight: 600,
        maxWidth: 600,
      );

      if (imageFile != null) {
        setState(() {
          _storedImage = File(imageFile.path);
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      overflow: Overflow.visible,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: (_storedImage == null)
                ? Image.asset('assets/images/user.jpg')
                : Image.file(_storedImage, fit: BoxFit.cover),
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
    );
  }
}
