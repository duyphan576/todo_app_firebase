import 'package:flutter/material.dart';

Widget customLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0.3,
    ),
  );
}

Widget customTitle(String title, TextEditingController controller, bool edit,
    BuildContext context) {
  return Container(
    height: 55,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Color.fromARGB(158, 139, 155, 225),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextFormField(
      controller: controller,
      enabled: edit,
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: title,
        hintStyle: TextStyle(
          color: Colors.white54,
          fontSize: 17,
        ),
        contentPadding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
      ),
    ),
  );
}

Widget customDescription(String description, TextEditingController controller,
    bool edit, BuildContext context) {
  return Container(
    height: 200,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Color.fromARGB(158, 139, 155, 225),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextFormField(
      controller: controller,
      enabled: edit,
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: description,
        hintStyle: TextStyle(
          color: Colors.white54,
          fontSize: 17,
        ),
        contentPadding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
      ),
    ),
  );
}

Widget customTextForm(String labeltext, TextEditingController controller,
    bool obscureText, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - 70,
    height: 55,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.indigoAccent.shade700,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.indigoAccent,
          ),
        ),
      ),
    ),
  );
}

LinearGradient gradientButtonColors() {
  return LinearGradient(colors: [
    Color.fromARGB(255, 108, 166, 253),
    Color.fromARGB(255, 104, 137, 255),
    Color.fromARGB(255, 108, 139, 253)
  ]);
}

LinearGradient gradientBgColors() {
  return LinearGradient(colors: [
    Color.fromARGB(255, 108, 209, 253),
    Color.fromARGB(255, 104, 190, 255),
    Color.fromARGB(255, 108, 161, 253)
  ]);
}
