import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  // getter
  Stream<User> get authStateChange {
    return _firebaseAuth.authStateChanges();
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential credential;

    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      print('INSIDE GENERIC Exception');
      print(e);
    }
    return credential;
  }

  Future<UserCredential> signUp(String email, String password) async {
    UserCredential credential;

    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      print('INSIDE GENERIC Exception');
      print(e);
    }

    return credential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
