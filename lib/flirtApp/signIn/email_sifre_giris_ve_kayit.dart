import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flirt/commonWidget/platform_duyarli_alert_dialog.dart';
import 'package:flutter_flirt/flirtApp/signIn/hata.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum FormType {Register, Login}

class EmailAndPaswordSignInPage extends StatefulWidget {
  @override
  _EmailAndPaswordSignInPageState createState() => _EmailAndPaswordSignInPageState();
}

class _EmailAndPaswordSignInPageState extends State<EmailAndPaswordSignInPage> {

  String _email, _sifre;
  String _buttonText, _linkText;
  var _formType =FormType.Login;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login ? "Hesabınız yoksa buraya tıklayıp kayıt olun" : "Hesabınız varsa buraya tıklayıp giriş yapın";

    final _userViewModel = Provider.of<UserViewModel>(context);

    if(_userViewModel.userModel != null){
      Future.delayed(Duration(milliseconds: 200),(){
        Navigator.of(context).pop();
      });

    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 80.0),
            Text("Giriş Ve Kayıt"),
          ],
        ),
      ),
      body: _userViewModel.state == ViewState.Idle ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.0),
                TextFormField(
                  initialValue: "ago@ago.com",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorText: _userViewModel.emailHata != null ? _userViewModel.emailHata : null,
                    prefixIcon: Icon(Feather.mail,color: Colors.green),
                    hintText: 'E-mail',
                    labelText: 'E-mail adresinizi girin',
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  onSaved: (String girilenEmail){
                    _email = girilenEmail;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: "password",
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText: _userViewModel.sifreHata != null ? _userViewModel.sifreHata : null,
                    prefixIcon: Icon(Ionicons.md_key,color: Colors.red),
                    hintText: 'Şifre',
                    labelText: 'Şifrenizi girin',
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  onSaved: (String girilenSifre){
                    _sifre = girilenSifre;
                  },
                ),
                SizedBox(height: 100.0),
                SizedBox(
                  height: 60.0,
                  child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _buttonText,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => _formSubmit(),
                  ),
                ), // giriş yapma ve kayıt olma butonu
                SizedBox(height: 30.0),
                FlatButton(
                    onPressed: () => _girisVeKayitDegistir(),
                  child: Text(
                    _linkText,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.purple,
                        letterSpacing: .5,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _formSubmit() async{
    _formKey.currentState.save();
    print("email: "+ _email +"şifre: "+ _sifre );
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if(_formType == FormType.Login){
      try{
        UserModel _girisYapnUser = await _userViewModel.signInWithEmailAndPasword(_email, _sifre);
        if(_girisYapnUser != null) {
          print("Giriş yapan user id : ${_girisYapnUser.userId}");
        }
      }on FirebaseException catch(e){
        PlatformDuyarliAlertDialog(
          title: 'Giriş Yapmada Bir Hata Oluştu',
          content: Hatalar.goster(e.message),
          mainButtonText: 'Tamam',
        ).goster(context);
      }
    }else{
      try{
        UserModel _olusturulanUser = await _userViewModel.creatUserWithEmailAndPasword(_email, _sifre);
        if(_olusturulanUser != null) {
          print("Kayıt olan user id : ${_olusturulanUser.userId}");
        }
      }on FirebaseException catch(e){
        PlatformDuyarliAlertDialog(
          title: 'Kayıt Olmada Bir Sorun Oluştu',
          content: Hatalar.goster(e.message),
          mainButtonText: 'Tamam',
        ).goster(context);
    }
  }
}
  _girisVeKayitDegistir() {
    setState(() {
      _formType = _formType == FormType.Login ? FormType.Register : FormType.Login;
    });}
}
