import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:set_me_app_1_try/helper/constants.dart';
import 'package:set_me_app_1_try/helper/helperfunctions.dart';
import 'package:set_me_app_1_try/services/auth.dart';
import 'package:set_me_app_1_try/services/database.dart';
import 'package:set_me_app_1_try/views/conversation_screen.dart';
import 'package:set_me_app_1_try/views/search.dart';
import 'package:set_me_app_1_try/views/signin.dart';
import 'package:set_me_app_1_try/widgets/widget.dart';

import '../widgets/navigationDrawer.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  late Stream chatRoomsStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    chatRoomsStream = databaseMethods.getChatRooms(Constants.myId);
  }

  Widget chatRoomList(){
    return StreamBuilder<dynamic>(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              String userName = snapshot.data.documents[index].data["usersName"][0];
              if (userName == Constants.myName) {
                userName = snapshot.data.documents[index].data["usersName"][1];
              }
              return ChatRoomTile(userName,
                  snapshot.data.documents[index].data["chatroomid"]
                      .toString().replaceAll("_", "").replaceAll(Constants.myId, ""),
                  snapshot.data.documents[index].data["chatroomid"]
              );
            }) : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Image.asset("assets/images/logo.png", height: 50,),
        ),
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String userId;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.userId, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
                child: Text(userName.substring(0, 1).toUpperCase())),
            const SizedBox(width: 8,),
            Text(userName, style: simpleTextStyle(),)
          ],
        ),
      ),
    );
  }
}
