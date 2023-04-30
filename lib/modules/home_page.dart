import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/main.dart';
import 'package:todo_app_firebase/modules/add_todo_page.dart';
import 'package:todo_app_firebase/modules/view_todo_page.dart';
import 'package:todo_app_firebase/services/auth_services.dart';
import 'package:todo_app_firebase/widgets/custom_widget.dart';
import 'package:todo_app_firebase/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authServices = AuthServices();
  late User? user;
  String? userEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    checkCurrentUser();
  }

  Future<void> getUserData() async {
    User? userData = FirebaseAuth.instance.currentUser;
    if (userData != null) {
      setState(() {
        user = userData;
      });
    }
  }

  Future<void> checkCurrentUser() async {
    String? currentUser = await authServices.getUser();
    if (currentUser != null) {
      setState(() {
        userEmail = currentUser;
      });
    }
  }

  // Khai báo biến _stream để chứa các snapshot đã thu thập được
  // thông qua collection có tên Todo được lưu trên Firestore Database
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  String idTodo = "";
  @override
  Widget build(BuildContext context) {
    getUserData();
    checkCurrentUser();
    _stream = FirebaseFirestore.instance
        .collection("Todo")
        .where("uid", isEqualTo: user!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: gradientBgColors(),
          ),
        ),
        title: Text(
          userEmail != null
              ? "Todo's Schedule of $userEmail"
              : "Todo's Schedule",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
          child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    // Xác định itemCount của ListView bằng độ dài của snapshot,
                    // trong trường hợp này là độ dài của _stream
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //Khởi tạo biến document cho từng snapshot để có thể truy cập vào data chứa trong đó
                      Map<String, dynamic> document = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ViewTodoPage(
                                        document: document,
                                        id: snapshot.data!.docs[index].id,
                                      )));
                        },
                        child: TodoCard(
                          // Giá trị của title sẽ là giá trị mà "title" chứa
                          title: document["title"],
                          iconButton: IconButton(
                            onPressed: () {
                              setState(() {
                                idTodo = snapshot.data!.docs[index].id;
                              });
                              // Sử dụng phương thức delele để xóa todo có id được chọn tương ứng
                              // trong Firestore Database
                              FirebaseFirestore.instance
                                  .collection("Todo")
                                  .doc(idTodo)
                                  .delete();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          checkBox: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            activeColor: Color.fromARGB(158, 139, 155, 225),
                            checkColor: Colors.white,
                            // value sẽ bằng giá trị mà "status" chứa
                            value: document["status"],
                            onChanged: (value) {
                              bool flag = !document["status"];
                              setState(() {
                                idTodo = snapshot.data!.docs[index].id;
                              });
                              // Sử dụng phương thức update của FirebaseFirestore để
                              // lưu trữ thông tin được thay đổi lên Firestore Database
                              FirebaseFirestore.instance
                                  .collection("Todo")
                                  .doc(idTodo)
                                  .update(
                                {
                                  "uid": document["uid"],
                                  "title": document["title"],
                                  "description": document["description"],
                                  "status": flag
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: gradientBgColors(),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => HomePage()),
                        (route) => false);
                  },
                  child: Icon(
                    Icons.home,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => AddTodoPage()));
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigoAccent,
                          Colors.purpleAccent,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () async {
                    try {
                      await authServices.signOut();
                      setState(() {
                        userEmail = "";
                      });
                    } on FirebaseAuthException catch (e) {
                      final snackbar =
                          SnackBar(content: Text(e.message.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => MyApp()),
                        (route) => false);
                  },
                  child: Icon(
                    Icons.logout,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                label: "",
              )
            ],
          )),
    );
  }
}
