import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userDetail;

  Future<void> getAndSetUserDetails() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    final userDoc =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    print(userDoc['username']);

    final user = UserModel(auth.currentUser!.uid, userDoc, auth.currentUser!);

    userDetail = user;
    notifyListeners();
  }
}
