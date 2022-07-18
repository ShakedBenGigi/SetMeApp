import 'package:flutter/material.dart';
import 'package:set_me_app_1_try/helper/helperfunctions.dart';
import 'package:set_me_app_1_try/services/auth.dart';
import 'package:set_me_app_1_try/services/database.dart';
import 'package:set_me_app_1_try/views/myProfile.dart';
import 'package:set_me_app_1_try/views/signin.dart';

import '../widgets/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);


  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signMeUp() {
    final isValidForm = formKey.currentState?.validate();
    if (isValidForm == true){

      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
          Map<String, dynamic> userInfoMap = {
            "name" : userNameTextEditingController.text,
            "email" : emailTextEditingController.text,
            "isAdmin" : false,
            "id" : val.userId,
            "bio" : "",
            "status" : "",
            "photoUrl" : "",
            "timestamp" : DateTime.now(),
          };
          databaseMethods.uploadUserInfo(userInfoMap, val.userId);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserIdSharedPreference(val.userId);
          HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const MyProfile()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: appBarMain(context),
      ),
      body: isLoading ? Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          if (val != null){
                            return val.isEmpty || val.length < 2 ? "Please provide a valid username" : null;
                          }
                          return null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("full name"),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val != null) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val) ? null : "Please provide a valid email address";
                          }
                          return null;
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if (val != null) {
                            return val.length > 5 ? null : "Please provide password with at least 6 characters";
                          }
                          return null;
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password?", style: simpleTextStyle(),),
                  ),
                ),
                const SizedBox(height: 8,),
                GestureDetector(
                  onTap: () {
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xff007EF4),
                            Color(0xff2A75BC),
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign Up", style: SignInButtonsTextStyle(Colors.white),),
                  ),
                ),
                const SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign Up with Google",
                    style: SignInButtonsTextStyle(Colors.lightBlue),
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: simpleTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => const SignIn()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("Sign in now", style: ForgotPasswordTextStyle(),)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


    