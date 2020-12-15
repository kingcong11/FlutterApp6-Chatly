import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class DatabaseHelper {

  // Future<QuerySnapshot> searchUsername(String keyword) async {
  //   try {
  //     return await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: keyword).get();
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<void> searchUsername(String keyword) async {
    try {
      return await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: keyword).get();
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
    } on PlatformException catch (e){
      throw e;
    } catch (e){
      throw e;
    }
  }
}
