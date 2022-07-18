import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:set_me_app_1_try/helper/constants.dart';
import 'package:set_me_app_1_try/services/database.dart';
import '../widgets/widget.dart';
import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot? searchSnapshot;

  initialSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text)
        .then((val) {
          setState(() {
            searchSnapshot = val;
          });
    });
  }

  createChatRoomAndStartConversation(String userName, String userId){

    if (userId != Constants.myId){
      String chatRoomId = getChatRoomId(userId, Constants.myId);

      List<String> usersId = [userId, Constants.myId];
      List<String> usersName = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "usersId": usersId,
        "usersName" : usersName,
        "chatroomid" : chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
      ));
    }
    else {
      print("you cannot send message to yourself!!!!!");
    }
  }

  Widget searchTile(String userId, String userName){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextStyle(),),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName, userId);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: simpleTextStyle(),),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot?.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return searchTile(searchSnapshot?.documents[0].data["id"], searchSnapshot?.documents[0].data["name"]);
      },
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: appBarMain(context),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0x54FFFFFF),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                        hintText: "Search username",
                        hintStyle: simpleTextStyle(),
                        border: InputBorder.none
                      ),
                    )
                ),
                GestureDetector(
                  onTap: (){
                    initialSearch();
                  },
                  child: Container(
                    height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset("assets/images/search_white.png")
                  ),
                )
              ],
            ),
          ),
          searchList()
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  }
  else {
    return "$a\_$b";
  }
}
