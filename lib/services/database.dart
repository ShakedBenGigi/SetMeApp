import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

class DatabaseMethods {

  AuthMethods authMethods = AuthMethods();

  getUserByUsername(String username) async {
    return await Firestore.instance.collection("users").
    where("name", isEqualTo: username).getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance.collection("users").
    where("email", isEqualTo: userEmail).getDocuments();
  }

  updateUserInfo(userId, userMap) async {
    final doc = await Firestore.instance.collection("users").document(
        userId).get();
    if (doc.exists) {
      doc.reference.updateData(userMap);
    }
  }

  uploadUserInfo(userMap, userId) {
    Firestore.instance.collection("users").document(userId).setData(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance.collection("ChatRoom").document(chatRoomId)
        .setData(chatRoomMap);
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance.collection("ChatRoom").document(chatRoomId)
        .collection("Chats").add(messageMap);
  }

  getConversationMessages(String chatRoomId) {
    return Firestore.instance.collection("ChatRoom").document(chatRoomId)
        .collection("Chats").orderBy("time", descending: false).snapshots();
  }

  getChatRooms(String userId) {
    return Firestore.instance.collection("ChatRoom").where(
        "usersId", arrayContains: userId).snapshots();
  }

  deleteUser(documentId) async {
    final doc = await Firestore.instance.collection("users").document(
        documentId).get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }
}

