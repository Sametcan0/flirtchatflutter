import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> currentUser() async{

    try{
      User user =  _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    }catch(e){
      print("hata current user : ${e.toString()}");
      return null;
    }

  }

  UserModel _userFromFirebase(User user){
    if (user == null){
      return null;
    }else{
      return UserModel(userId: user.uid, email: user.email);
    }
  }

  @override
  Future<UserModel> signInAnonuymously() async{

    // AuthResult => UserCredential
    try{
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    }catch(e){
      print("sign in anonuymously hata : ${e.toString()}");
      return null;
    }
  }

  @override
  Future<bool> signOut() async{
    try{
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    }catch(e){
      print("sign out hata : ${e.toString()}");
      return false;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async{
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if(_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if(_googleAuth.idToken != null && _googleAuth.accessToken != null){
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken,
            accessToken: _googleAuth.accessToken,
          ),
        );
        User _user = sonuc.user; // User => FirebaseUser
        return _userFromFirebase(_user);
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async{
    final _facebooklogin = FacebookLogin();

    FacebookLoginResult _facebookResult = await _facebooklogin.logIn(["email","public_profile"]);

    switch(_facebookResult.status){
      case FacebookLoginStatus.loggedIn:

        if(_facebookResult.accessToken != null){
          UserCredential userCredential =  await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.credential(_facebookResult.accessToken.token
              ));


          String accessToken = _facebookResult.accessToken.token;
          User facebookUser = userCredential.user;
          return _userFromFacebook(facebookUser,accessToken);

        }

        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Kullanıcı Facebook girişini Reddeetti : "+_facebookResult.errorMessage);
        break;

      case FacebookLoginStatus.error:
        print(" Facebook Girişi Hatası : "+_facebookResult.errorMessage);
        break;
    }
    return null;
  }
  Future<UserModel> _userFromFacebook(User user, String accesToken) async{
    return UserModel(userId: user.uid, email: user.email);
  }

  @override
  Future<UserModel> creatUserWithEmailAndPasword(String email, String sifre) async{
      UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: sifre);
      return _userFromFirebase(sonuc.user);
  }

  @override
  Future<UserModel> signInWithEmailAndPasword(String email, String sifre) async{
      UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: sifre);
      return _userFromFirebase(sonuc.user);
  }

}
