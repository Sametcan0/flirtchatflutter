import 'package:flutter/material.dart';
import 'package:flutter_flirt/flirtApp/signIn/email_sifre_giris_ve_kayit.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



//ignore: must_be_immutable
class SignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150.0),
              Text(
                "OTURUM AÇIN",
                style: GoogleFonts.balooDa(
                  textStyle: TextStyle(
                    color: Colors.deepPurple,
                    letterSpacing: .5,
                    fontSize: 40.0,
                  ),
                ),
              ),
              SizedBox(height: 80.0),
              SizedBox(
                height: 50,
                width: 280,
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Color(0xffe94235),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20.0),
                      Icon(
                        AntDesign.google,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Google İle Giriş Yap",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 15.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  onPressed: () => _googleGirisi(context),
                ),
              ), // Google ile oturum açma butonu
              SizedBox(height: 20.0),
              SizedBox(
                height: 50,
                width: 280,
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Color(0xff1877f2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20.0),
                      Icon(
                        AntDesign.facebook_square,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Facebook İle Giriş Yap",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 15.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  onPressed: () => _facebookGirisi(context),
                ),
              ), // Facebook ile oturum açma butonu
              SizedBox(height: 20.0),
              SizedBox(
                height: 50,
                width: 280,
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  color: Color(0xfffabb05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20.0),
                      Icon(
                        Feather.mail,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Email Ve Şifre İle Giriş Yap",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 15.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  onPressed: () => _emailVeSifreGirisi(context),
                ),
              ), // Email ve şifre ile oturum açma butonu
            ],
          ),
        ),
      ),
    );
  }

  void _googleGirisi(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userViewModel.signInWithGoogle();
    if(_user != null) {
      print("Oturum açan user id : ${_user.userId}");
    }
  }

  void _facebookGirisi(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userViewModel.signInWithFacebook();
    if(_user != null) {
      print("Oturum açan user id : ${_user.userId}");
    }
  }

  void _emailVeSifreGirisi(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context)=> EmailAndPaswordSignInPage(),
        ),
    );
  }
}

