import 'dart:io';

import 'package:flutter_flirt/locator.dart';
import 'package:flutter_flirt/model/chat_model.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/model/usually_chat_model.dart';
import 'package:flutter_flirt/services/auth_base.dart';
import 'package:flutter_flirt/services/fake_auth_service.dart';
import 'package:flutter_flirt/services/firebase_auth_service.dart';
import 'package:flutter_flirt/services/firebase_storage_service.dart';
import 'package:flutter_flirt/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<UserModel> tumKullaniciListesi = [];

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel _userModel = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_userModel.userId, );
    }
  }

  @override
  Future<UserModel> signInAnonuymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonuymously();
    } else {
      return await _firebaseAuthService.signInAnonuymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserModel _userModel = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_userModel);
      if (_sonuc == true) {
        return _firestoreDBService.readUser(_userModel.userId);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      UserModel _userModel = await _firebaseAuthService.signInWithFacebook();
      bool _sonuc = await _firestoreDBService.saveUser(_userModel);
      if (_sonuc == true) {
        return _firestoreDBService.readUser(_userModel.userId);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> creatUserWithEmailAndPasword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.creatUserWithEmailAndPasword(email, sifre);
    } else {
      UserModel _userModel =
          await _firebaseAuthService.creatUserWithEmailAndPasword(email, sifre);
      bool _sonuc = await _firestoreDBService.saveUser(_userModel);
      if (_sonuc == true) {
        return await _firestoreDBService.readUser(_userModel.userId);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPasword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPasword(email, sifre);
    } else {
      UserModel _userModel =
          await _firebaseAuthService.signInWithEmailAndPasword(email, sifre);
      return _firestoreDBService.readUser(_userModel.userId);
    }
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return _firestoreDBService.updateUserName(userId, newUserName);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return 'Dosya indirme linki';
    } else {
      var profilePhotoUrl = await _firebaseStorageService.uploadFile(
          userId, fileType, profilePhoto);
      await _firestoreDBService.updateProfilePhoto(userId, profilePhotoUrl);
      return profilePhotoUrl;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _firestoreDBService.getAllUsers();
      return tumKullaniciListesi;
    }
  }

  Stream<List<ChatModel>> getMessages(
      String currentSenderUserId, String currentReceiverUserId) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(
          currentSenderUserId, currentReceiverUserId);
    }
  }

  Future<bool> saveMessage(ChatModel saveMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firestoreDBService.saveMessage(saveMessage);
    }
  }

  Future<List<UsuallyChatModel>> getAllUsuallyChat(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var chatList = await _firestoreDBService.getAllUsuallyChat(userId);

      for (var currentChat in chatList) {
        var listInUser = findUserInList(currentChat.messageReceiver);

        if (listInUser != null) {
          print("veriler locale cache den okundu");
          currentChat.receiverUserName = listInUser.userName;
          currentChat.receiverProfileUrl = listInUser.profileUrl;
        }else{
          print("veriler database den okundu");
          print("aranılan user veri tabanından getrilmemiş veri tabanından okumalıyız");
          var _readUserInDatabase = await _firestoreDBService.readUser(currentChat.messageReceiver);
          currentChat.receiverUserName = _readUserInDatabase.userName;
          currentChat.receiverProfileUrl = _readUserInDatabase.profileUrl;
        }
      }
      return chatList;
    }
  }

  UserModel findUserInList(String userId) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userId == userId) {
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }

  Future<UserModel> readUser(String userId) async{
    var result = await _firestoreDBService.readUser(userId);
    return result;
  }

}
