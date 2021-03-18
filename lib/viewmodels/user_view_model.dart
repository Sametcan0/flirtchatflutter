import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_flirt/locator.dart';
import 'package:flutter_flirt/model/chat_model.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/model/usually_chat_model.dart';
import 'package:flutter_flirt/repository/user_repository.dart';
import 'package:flutter_flirt/services/auth_base.dart';


enum ViewState{Idle, Busy}

class UserViewModel with ChangeNotifier implements AuthBase{

  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel _userModel;
  String emailHata;
  String sifreHata;

  UserModel get userModel => _userModel;

  ViewState get state => _state; // (Avoid wrapping fields in getters and setters just to be "safe") => notifyListeners(); kullan

  set state(ViewState value) {
    _state = value;
    notifyListeners();
    print(_state);
  }

  UserViewModel(){
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async{
    try{
      state = ViewState.Busy;
      _userModel = await _userRepository.currentUser();
      if(_userModel != null){
        return _userModel;
      }else{
        return null;
      }
    }catch(e){
      debugPrint("View modeldeki current user da hata :" + e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInAnonuymously() async{
    try{
      state = ViewState.Busy;
      _userModel = await _userRepository.signInAnonuymously();
      return _userModel;
    }catch(e){
      debugPrint("View modeldeki sign anonuymously de hata :" + e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async{
    try{
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _userModel = null;
      return sonuc;
    }catch(e){
      debugPrint("View modeldeki sign out da hata :" + e.toString());
      return false;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async{
    state = ViewState.Busy;
    _userModel = await _userRepository.signInWithGoogle();
    state = ViewState.Idle;
    return _userModel;
  }

  @override
  Future<UserModel> signInWithFacebook() async{
    try{
      state = ViewState.Busy;
      _userModel = await _userRepository.signInWithFacebook();
      return _userModel;
    }catch(e){
      debugPrint("View modeldeki sign in with facebook da hata :" + e.toString());
      return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> creatUserWithEmailAndPasword(String email, String sifre) async{

      if(_emailVeSifreKontrol(email, sifre)) {
          try{
            state = ViewState.Busy;
            _userModel =
            await _userRepository.creatUserWithEmailAndPasword(email, sifre);
            return _userModel;
          }finally{
            state = ViewState.Idle;
          }
      }else return null;
  }

  @override
  Future<UserModel> signInWithEmailAndPasword(String email, String sifre) async{
    try{
      if(_emailVeSifreKontrol(email, sifre)){
        state = ViewState.Busy;
        _userModel = await _userRepository.signInWithEmailAndPasword(email, sifre);
        return _userModel;
      }else return null;
    }finally{
      state = ViewState.Idle;
    }
  }

  bool _emailVeSifreKontrol(String email, String sifre){
    var sonuc = true;

    if(sifre.length < 6){
     sifreHata = "Şifreniz en az 6 karakter olmalı";
     sonuc = false;
    }else sifreHata = null;
    if(!email.contains('@')){
      emailHata = "Geçersiz e-mail adresi";
      sonuc = false;
    }else emailHata = null;
    return sonuc;
  }

  Future<bool> updateUserName(String userId, String newUserName) async{
    var sonuc = await _userRepository.updateUserName(userId, newUserName);
    if(sonuc == true){
      _userModel.userName = newUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(String userId, String fileType, File profilePhoto) async{
    var downloadLink = await _userRepository.uploadFile(userId, fileType, profilePhoto);
    return downloadLink;
  }

  Future<List<UserModel>> getAllUsers() async{
    var tumKullaniciListesi = await _userRepository.getAllUsers();
    return tumKullaniciListesi;
  }

  Stream<List<ChatModel>> getMessagees(String currentSenderUserId, String currentReceiverUserId) {
    return _userRepository.getMessages(currentSenderUserId, currentReceiverUserId);
  }

  Future<bool> saveMessage(ChatModel saveMessage) async{
    return await _userRepository.saveMessage(saveMessage);
  }

  Future<List<UsuallyChatModel>> getAllUsuallyChat(String userId) async{
    return await _userRepository.getAllUsuallyChat(userId);
  }
}