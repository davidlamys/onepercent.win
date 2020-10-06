import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_win_2/Model/record.dart';

class User {
  final String userId;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String currentQuote;
  final DateTime memberSince;

  User(
      {this.userId,
      this.username,
      this.email,
      this.photoUrl,
      this.currentQuote,
      this.displayName,
      this.memberSince});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        userId: doc['userId'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        currentQuote: doc['currentQuote'],
        memberSince: parseTime(doc['memberSince']));
  }

  Map<String, dynamic> data() {
    return {
      "userId": userId,
      "email": email,
      "username": username,
      "photoUrl": photoUrl,
      "displayName": displayName,
      "currentQuote": currentQuote,
      "memberSince": memberSince
    };
  }
}
