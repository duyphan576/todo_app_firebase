import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app_firebase/modules/home_page.dart';
import 'package:todo_app_firebase/modules/sign_in_page.dart';
import 'package:todo_app_firebase/services/auth_services.dart';
import 'settings/firebase_options.dart';

// ...

Future<void> main() async {
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
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    String? token = await authServices.getToken();
    String? user = await authServices.getUser();
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
