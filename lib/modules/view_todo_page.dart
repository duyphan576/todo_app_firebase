import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/widgets/custom_widget.dart';

class ViewTodoPage extends StatefulWidget {
  const ViewTodoPage({super.key, required this.document, required this.id});
  final Map<String, dynamic> document;
  final String id;

  @override
  State<ViewTodoPage> createState() => _ViewTodoPageState();
}

class _ViewTodoPageState extends State<ViewTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _desController = TextEditingController();
  bool circular = false;
  bool edit = false;
  late User? user;
  Future<void> getUserData() async {
    User? userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document["title"]);
    _desController =
        TextEditingController(text: widget.document["description"]);
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
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                });
              },
              icon: Icon(
                Icons.edit,
                color: edit ? Colors.green : Colors.white,
              ))
        ],
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
                            edit ? "Editing Todo" : "Viewing Todo",
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
                          customLabel("Task Title"),
                          SizedBox(
                            height: 20,
                          ),
                          customTitle("Title", _titleController, edit, context),
                          SizedBox(
                            height: 20,
                          ),
                          customLabel("Description"),
                          SizedBox(
                            height: 20,
                          ),
                          customDescription(
                              "Description", _desController, edit, context),
                          SizedBox(
                            height: 60,
                          ),
                          edit ? customButton() : Container(),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget customButton() {
    return InkWell(
      onTap: () async {
        if (_titleController.text.isNotEmpty &&
            _desController.text.isNotEmpty) {
          setState(() {
            circular = true;
          });
          try {
            FirebaseFirestore.instance
                .collection("Todo")
                .doc(widget.id)
                .update({
              "uid": widget.document["uid"],
              "title": _titleController.text,
              "description": _desController.text,
              "status": widget.document["status"]
            });
            setState(() {
              circular = false;
              edit = !edit;
            });
            final snackbar = SnackBar(content: Text("Update todo success."));
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
                  "Update Todo",
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
