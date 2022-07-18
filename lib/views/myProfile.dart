import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:set_me_app_1_try/helper/constants.dart';
import 'package:set_me_app_1_try/widgets/navigationDrawer.dart';
import '../helper/helperfunctions.dart';
import '../widgets/widget.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  File? file;
  TextEditingController bioEditingController = TextEditingController();

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext){
    return showDialog(context: parentContext,
        builder: (context) {
      return SimpleDialog(
        title: const Text("Upload Photo", style: TextStyle(color: Colors.black),),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text("Photo with Camera", style: TextStyle(color: Colors.black26)),
            onPressed: handleTakePhoto,
          ),
          SimpleDialogOption(
            child: const Text("Image from Gallery", style: TextStyle(color: Colors.black26)),
            onPressed: handleChooseFromGallery,
          ),
          SimpleDialogOption(
            child: const Text("Cancel", style: TextStyle(color: Colors.black26)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
        });
  }

  editProfilePic(){
    return selectImage(context);
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myId = await HelperFunctions.getUserIdSharedPreference();
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    // update bio, photoUrl etc..
  }

  Scaffold buildFirstProfile() {
    return Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: appBarMain(context),
        ),
        body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  GestureDetector(
                    onTap: (){
                      editProfilePic();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 120,
                      child: CircleAvatar(
                        backgroundImage:
                        NetworkImage("https://www.pngplay.com/wp-content/uploads/8/Upload-Icon-Logo-PNG-Photos.png"),
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Text(Constants.myName, style: ProfileTextStyle()),
                  const SizedBox(height: 20,),
                  Text(Constants.status, style: simpleTextStyle(),),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    alignment: Alignment.topLeft,
                    child: Text(Constants.myBio, style: simpleTextStyle(),),
                  ),
                  const SizedBox(height: 100,),
                ],
              ),
            )
        ));
  }

  Scaffold buildUploadProfile() {
    return Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: appBarMain(context),
        ),
        body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  GestureDetector(
                    onTap: (){
                      editProfilePic();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 120,
                      child: CircleAvatar(
                        radius: 110,
                        backgroundImage:
                        FileImage(file!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Text(Constants.myName, style: ProfileTextStyle()),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const SizedBox(width: 20,),
                      Text("status: ", style: simpleTextStyle(),),
                      DropdownButton(items: const [
                        DropdownMenuItem(child: Text("single"), value: "single",),
                        DropdownMenuItem(child: Text("in a relationship"), value: "in a relationship",),
                        DropdownMenuItem(child: Text("it's complicated"), value: "it's complicated",),
                      ], onChanged: (String? newValue) {
                        setState(() {
                          if (newValue != null){
                            Constants.status = newValue;
                          }
                        },
                        );
                      }),
                    ],
                  ),




                  // Text(Constants.status, style: simpleTextStyle(),),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    alignment: Alignment.topLeft,
                    child: TextFormField(
                      validator: (val) {
                        if (val != null) {
                          return val.isEmpty ? null : "Please add a description about yourself";
                        }
                        return null;
                      },
                      decoration: textFieldInputDecoration(Constants.myBio),
                      style: simpleTextStyle(),
                      controller: bioEditingController,
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  //   alignment: Alignment.topLeft,
                  //   child: Text(Constants.myBio, style: simpleTextStyle(),),
                  // ),
                ],
              ),
            )
        ));
  }

  @override
  Widget build(BuildContext context) {
    // return buildFirstProfile();
    if (file == null) {
      return buildFirstProfile();
    } else {
      return buildUploadProfile();
    }

  }
}
