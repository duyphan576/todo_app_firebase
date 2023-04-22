import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/widgets/custom_widget.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _tilteController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  bool circular = false;
  late User? user;
  Future<void> getUserData() async {
    User? userData = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    getUserData();
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
            decoration: BoxDecoration(
              gradient: gradientBgColors(),
            ),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create New Todo",
                            style: TextStyle(
                              fontSize: 33,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          customLabel("Task Tilte"),
                          SizedBox(
                            height: 20,
                          ),
                          customTitle("Title", _tilteController, true, context),
                          SizedBox(
                            height: 20,
                          ),
                          customLabel("Description"),
                          SizedBox(
                            height: 20,
                          ),
                          customDescription(
                              "Description", _desController, true, context),
                          SizedBox(
                            height: 60,
                          ),
                          customButton(),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget customButton() {
    getUserData();
    return InkWell(
      onTap: () async {
        if (_tilteController.text.isNotEmpty &&
            _desController.text.isNotEmpty) {
          setState(() {
            circular = true;
          });
          try {
            FirebaseFirestore.instance.collection("Todo").add({
              "uid": "${user?.uid}",
              "title": _tilteController.text,
              "description": _desController.text,
              "status": false,
            });
            setState(() {
              circular = false;
            });
            Navigator.pop(context);
            final snackbar = SnackBar(content: Text("Add new todo success."));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          } catch (e) {}
        } else {
          final snackbar =
              SnackBar(content: Text("Title or description is empty."));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradientButtonColors(),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  "Add New Todo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
