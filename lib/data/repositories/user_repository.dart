// lib/data/repositories/user_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_my_app/data/models/index.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _userBox = Hive.box<AppUser>('userBox');

  Future<AppUser?> getCurrentUser() async {
    if (_userBox.isNotEmpty) {
      return _userBox.getAt(0);
    }
    final user = _auth.currentUser;
    if (user == null) return null;
    final appUser = AppUser(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
    await _userBox.put(0, appUser);
    return appUser;
  }

  Future<AppUser> loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in aborted');
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;
    final appUser = AppUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );

    await _userBox.put(0, appUser);
    return appUser;
  }

  Future<AppUser> loginWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user!;
    final appUser = AppUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );

    await _userBox.put(0, appUser);
    return appUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _userBox.clear();
  }
}
