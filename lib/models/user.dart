import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  var userData;
  final User user;

  UserModel(this.uid, this.userData, this.user);
}
