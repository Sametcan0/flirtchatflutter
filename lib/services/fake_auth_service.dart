import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/services/auth_base.dart';

class FakeAuthService implements AuthBase{

  String userID = "12312523423523";
  @override
  Future<UserModel> currentUser() async{
    return await Future.value(UserModel(userId: userID, email: "fakeago@ago.com"));
  }

  @override
  Future<UserModel> signInAnonuymously() async{
    return await Future.delayed(Duration(seconds: 2), ()=> UserModel(userId: userID, email: "fakeago@ago.com"));
  }

  @override
  Future<bool> signOut() async{
    return true;
    //  bu yöntem de kullanılabilir => return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() async{
    return await Future.delayed(Duration(seconds: 2), ()=> UserModel(
        userId: "google user id = 1265723658734",
        email: "fakeago@ago.com",
    ));
  }

  @override
  Future<UserModel> signInWithFacebook() async{
    return await Future.delayed(Duration(seconds: 2), ()=> UserModel(
        userId: "facebook user id = 72133876938744",
        email: "fakeago@ago.com",
    ));
  }

  @override
  Future<UserModel> creatUserWithEmailAndPasword(String email, String sifre) async{
    return await Future.delayed(Duration(seconds: 2), ()=> UserModel(
        userId: "creat olan user id = 87987723658734",
        email: "fakeago@ago.com",
    ));
  }

  @override
  Future<UserModel> signInWithEmailAndPasword(String email, String sifre) async{
    return await Future.delayed(Duration(seconds: 2), ()=> UserModel(
        userId: "sign iin user id = 9923723658734",
        email: "fakeago@ago.com",
    ));
  }

}