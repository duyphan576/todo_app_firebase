import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices {
  final storage = FlutterSecureStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOut({BuildContext? context}) async {
    try {
      await auth.signOut();
      await storage.delete(key: "token");
      await storage.delete(key: "usercredential");
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: auth.currentUser!.getIdToken().toString());
    await storage.write(key: "usercredential", value: auth.currentUser?.email);
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<String?> getUser() async {
    return await storage.read(key: "usercredential");
  }
}
