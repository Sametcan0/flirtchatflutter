import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel{

  final String userId;
  String email;
  String userName;
  String profileUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int level;

  UserModel({@required this.userId, @required this.email});

  // user yapısını map yapısına çevirme işlemi
  Map<String, dynamic> toMap(){
    Map<String, dynamic> asd = {
      'email' : email,
      'userId' : userId,
      'userName' : userName ?? email.substring(0, email.indexOf('@')) + randomSayiUret(),
      'profileUrl' : profileUrl ?? 'https://images.hdqwalls.com/wallpapers/wish-you-were-here-4k-45.jpg',
      'createdAt' : createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt' : updatedAt ?? FieldValue.serverTimestamp(),
      'level' : level ?? 0,
    };
    print(asd);
    return asd;
  }

  // map yapısını user yapısına çevirme işlemi
  UserModel.fromMap(Map<String, dynamic> map) :
        userId = map['userId'],
        email = map['email'],
        userName = map['userName'],
        profileUrl = map['profileUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, userName: $userName, profileUrl: $profileUrl, level: $level}'; //createdAt: $createdAt, updatedAt: $updatedAt,
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(9999);
    return rastgeleSayi.toString();
  }


}