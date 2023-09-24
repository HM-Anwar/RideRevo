import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/models/rider.dart';

class UserRepo {
  User? get getUser => FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<AppUser> getUserDetails() async {
    final rawData = await userCollection.doc(getUser!.uid).get();
    AppUser appUser = AppUser.fromJson(rawData.data()!);
    return appUser;
  }

  Future<void> updateUserDetails(AppUser appUser) async {
    await userCollection.doc(getUser!.uid).update(appUser.toJson());
  }

  Future<Rider> getRiderDetails() async {
    final riderId = getUser!.uid;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("riders/$riderId");
    final snapshot = await dbRef.get();
    final jsonRider = jsonEncode(snapshot.value);
    final riderMap = jsonDecode(jsonRider);

    Rider rider = Rider.fromJson(riderMap);

    return rider;
  }

  Future<void> updateRiderDetails(Rider rider) async {
    final riderId = getUser!.uid;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("riders/$riderId");
    await dbRef.update(rider.toJson());
  }
}
