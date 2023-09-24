import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/views/widgets/app_snackbar.dart';

class AuthRepo {
  static User? get getUser => FirebaseAuth.instance.currentUser;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<ResponseStatus> signUpWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await firebaseAuth.signInWithCredential(googleAuthCredential);
      return ResponseStatus.success;
    } catch (e) {
      debugPrint(e.toString());
      return ResponseStatus.failed;
    }
  }

  static Future<bool> checkAppProfile() async {
    try {
      AppController appController = Get.find<AppController>();
      late DocumentSnapshot<Map<String, dynamic>> snapshot;
      if (appController.appMode!.user) {
        snapshot = await FirebaseFirestore.instance.collection('users').doc(getUser!.uid).get();
        debugPrint('===> USER EXIST: ${snapshot.exists}');
        return snapshot.exists;
      } else {
        final riderId = getUser!.uid;
        DatabaseReference dbRef = FirebaseDatabase.instance.ref("riders/$riderId");
        final snapshot = await dbRef.get();
        print(snapshot.value);
        debugPrint('===> RIDER EXIST: ${snapshot.exists}');
        return snapshot.exists;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool?> isUserProfile() async {
    AppController appController = Get.find<AppController>();
    AppMode? appMode;
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(getUser!.uid).get();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("riders/${getUser!.uid}");
    final riderSnapshot = await dbRef.get();

    if (userSnapshot.exists) appMode = AppMode.user;

    if (riderSnapshot.exists) appMode = AppMode.rider;

    if (appMode != null) {
      if (appMode == appController.appMode) return true;
      Get.showSnackbar(
        appSnackBar(
          message: 'You are using a different account type',
          isErrorSnackBar: true,
        ),
      );
      await firebaseAuth.signOut();
      return false;
    }
    return null;
  }
}
