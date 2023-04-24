import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/widgets/custom_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: gradientBgColors(),
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 108, 209, 253),
                Color.fromARGB(255, 104, 190, 255),
                Color.fromARGB(255, 108, 161, 253)
              ]),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Enter your email and we will send you a password reset link.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  customTextForm("Email", _emailController, false, context),
                  const SizedBox(
                    height: 40,
                  ),
                  customButton(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget customButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          await firebaseAuth.sendPasswordResetEmail(
              email: _emailController.text);
          final snackbar = SnackBar(
              content: Text('Password reset link was sent to your email.'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        } on FirebaseAuthException catch (e) {
          final snackbar = SnackBar(content: Text(e.message.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradientButtonColors(),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
