import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app_firebase/modules/home_page.dart';
import 'package:todo_app_firebase/modules/sign_in_page.dart';
import 'package:todo_app_firebase/services/auth_services.dart';
import 'settings/firebase_options.dart';

// ...

Future<void> main() async {
  //Khai báo các thuộc tính bắt buộc khi ứng dụng có sử dụng Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignInPage();
  // Khởi tạo biến authServices để truy cập vào class AuthServices
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  // Dùng phương thức getToken đã được xây dựng ở class AuthServices
  // để check xem đã có token nào được lưu hay chưa, nếu đã có
  // thì truy cập thẳng vào HomePage,
  checkLogin() async {
    String? token = await authServices.getToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentPage,
    );
  }
}
