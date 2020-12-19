import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseHelper {
  var _userCredentials = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getCurrentUserInfo() async {
    try {
      final userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();

      // print('userInfo');
      return userInfo.data();
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String userUid) async {
    try {
      final userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      return userInfo.data();
    } catch (e) {
      throw e;
    }
  }

  Future<void> searchUsername(String keyword) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: keyword)
          .get();
    } catch (e) {
      throw e;
    }
  }

  Future<void> markMessagesAsRead(
      String chatId, String participantUserUid) async {
    var batch = FirebaseFirestore.instance.batch();
    try {
      await FirebaseFirestore.instance
          .collection('chats/$chatId/messages')
          .where('userId', isEqualTo: participantUserUid)
          .get()
          .then((response) {
        response.docs.forEach((message) {
          batch.update(message.reference, {
            'isRead': true,
          });
        });

        batch.commit();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> uploadUserInfo(String userId, Map userInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userInfo);
    } on FirebaseAuthException catch (e) {
      throw e;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<void> uploadProfilePicture(File image) async {
    try {
      final uploadRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child(_userCredentials.uid + '.jpg');
      await uploadRef.putFile(image);
      final downloadUrl = await uploadRef.getDownloadURL();

      // update user data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredentials.uid)
          .update({
        'profileImageUrl': downloadUrl,
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
