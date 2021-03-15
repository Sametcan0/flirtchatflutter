import 'package:flutter_flirt/model/user_model.dart';

abstract class AuthBase {

  Future<UserModel> currentUser();
  Future<UserModel> signInAnonuymously();
  Future<bool> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<UserModel> signInWithEmailAndPasword(String email, String sifre);
  Future<UserModel> creatUserWithEmailAndPasword(String email, String sifre);
}