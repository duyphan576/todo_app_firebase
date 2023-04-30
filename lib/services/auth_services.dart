import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices {
  //Khai báo biến storage để có thể truy cập vào FlutterSecureStorage
  final storage = FlutterSecureStorage();
  //Khai báo biến auth để truy cập vào Firebase Auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOut({BuildContext? context}) async {
    try {
      //Sử dụng phương thức signOut của Firebase Auth
      await auth.signOut();
      //Sử dụng phương thức delete để xóa những key đã được lưu trước đó
      await storage.delete(key: "token");
      await storage.delete(key: "usercredential");
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    //Data sẽ được vào SharedPreference dưới dạng encryptedSharedPreference
    //Lưu trữ các dữ liệu IdToken cũng như email của user đăng nhập
    await storage.write(
        key: "token", value: auth.currentUser!.getIdToken().toString());
    await storage.write(key: "usercredential", value: auth.currentUser?.email);
  }

  //Truy xuất các dữ liệu đó từ storage
  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<String?> getUser() async {
    return await storage.read(key: "usercredential");
  }
}
