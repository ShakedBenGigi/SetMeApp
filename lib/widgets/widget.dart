import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.png", height: 40,),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.black26,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}

TextStyle simpleTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle ProfileTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 30,
  );
}

TextStyle SignInButtonsTextStyle(Color color) {
  return TextStyle(
    color: color,
    fontSize: 17,
  );
}

TextStyle ForgotPasswordTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 16,
    decoration: TextDecoration.underline,
  );
}