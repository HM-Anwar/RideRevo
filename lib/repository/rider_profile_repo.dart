import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/constants.dart';
import 'package:uuid/uuid.dart';

class RiderProfileRepo {
  Future<void> createUserFromDB(Rider rider) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref('riders/${AuthRepo.getUser!.uid}');
      await dbRef.set(rider.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> pickImage() async {
    final imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return imageFile;
  }

  Future<String> createURLFromFirebase(File file) async {
    Reference reference = FirebaseStorage.instance.refFromURL(Constants.FIREBASE_STORAGE_URL).child(
          'riders/${AuthRepo.getUser!.email}/${AuthRepo.getUser!.uid}-${const Uuid().v1()}',
        );
    var snapshot = await reference.putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
