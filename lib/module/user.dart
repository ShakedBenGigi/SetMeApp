import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String name;
  final String bio;
  final String email;
  final String status;
  final String photoUrl;

  User({required this.userId, required this.name, required this.bio,
    required this.email, required this.status, required this.photoUrl});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(userId: doc['id'], name: doc['name'], bio: doc['bio'],
        email: doc['email'], status: doc['status'], photoUrl: doc['photoUrl']);
  }
}