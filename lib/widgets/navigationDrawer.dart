import 'package:flutter/material.dart';
import 'package:set_me_app_1_try/helper/constants.dart';
import 'package:set_me_app_1_try/helper/helperfunctions.dart';
import 'package:set_me_app_1_try/views/chatRoomScreen.dart';
import 'package:set_me_app_1_try/views/myProfile.dart';
import 'package:set_me_app_1_try/views/signin.dart';
import 'package:set_me_app_1_try/widgets/widget.dart';
import '../helper/helperfunctions.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            buildHeader(
              urlImage: Constants.myProfilePic,
              name: Constants.myName,
              onClicked: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyProfile()))
            ),
            buildMenuItem(
              text: 'Friends',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
                text: 'Chat',
                icon: Icons.chat,
                onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 230),
            const Divider(color: Colors.white70,),
            buildMenuItem(
                text: 'Settings',
                icon: Icons.settings,
                onClicked: () => selectedItem(context, 3),
            ),
            buildMenuItem(
                text: 'Help',
                icon: Icons.help,
                onClicked: () => selectedItem(context, 4),
            ),
            buildMenuItem(
              text: 'Log out',
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 5),
            ),
          ],
        ),
      ),
    );
  }

  selectedItem(BuildContext context, int i) {
    Navigator.of(context).pop();
    switch (i) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyProfile()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatRoom()));
        break;
      case 5:
        HelperFunctions.saveUserLoggedInSharedPreference(false);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignIn()));
        break;
    }
  }
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required VoidCallback onClicked
}) => InkWell(
  onTap: onClicked,
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Row(
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
        const SizedBox(width: 20),
        Text(name, style: simpleTextStyle())
      ],
    ),
  ),
);

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {

  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(text, style: const TextStyle(color: Colors.white)),
    hoverColor: Colors.white70,
    onTap: onClicked,
  );
}
