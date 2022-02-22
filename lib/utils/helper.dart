import 'package:cloud_firestore/cloud_firestore.dart';

class Helper {
  static Future<bool> usernameExists(String username) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final usernameFound = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return usernameFound.docs.isNotEmpty;
  }

  // static bool usernameExistst(String username) async {
  //   bool userExists = false;

  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   firestore
  //       .collection('users')
  //       .where('username', isEqualTo: username)
  //       .get()
  //       .then((value) {
  //         if(value.docs.isNotEmpty){}
  //       });

  //   // return usernameFound.docs.isNotEmpty;
  // }
}
