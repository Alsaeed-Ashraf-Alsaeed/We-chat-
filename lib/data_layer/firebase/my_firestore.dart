import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyFireStore {
  static void readFireStore() async {}

  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  static Future<String> currentUserDocId() async {
    var currentUserRef = (await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get())
        .docs[0]
        .reference
        .id;
    return currentUserRef;
  }
}
