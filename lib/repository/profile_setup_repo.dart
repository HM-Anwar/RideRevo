import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/utils/constants.dart';
import 'package:uuid/uuid.dart';

class ProfileSetupRepo {
  Future<void> createUserFromFirebase(AppUser user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.rideId).set(user.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> pickImage() async {
    final imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return imageFile;
  }

  Future<String> createURLFromFirebase(User user, File file) async {
    Reference reference = FirebaseStorage.instance.refFromURL(Constants.FIREBASE_STORAGE_URL).child(
          '${user.email}/${user.uid}-${const Uuid().v1()}',
        );
    var snapshot = await reference.putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
