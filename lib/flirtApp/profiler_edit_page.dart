import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter_flirt/commonWidget/platform_duyarli_alert_dialog.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  TextEditingController _controllerUserName;
  File _profilePhoto;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _controllerUserName.text = _userViewModel.userModel.userName;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Profil Düzenle"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: (){
                  _profilIcinAlanSecmek();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 60.0,
                  backgroundImage: _profilePhoto == null ? NetworkImage(_userViewModel.userModel.profileUrl) : FileImage(_profilePhoto),
                ),
              ),
              TextButton(
                  onPressed: (){
                    _profilIcinAlanSecmek();
                  },
                  child: Text(
                      'Profil Fotoğrafını Değiştir',
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  //initialValue: _userViewModel.userModel.userName, => controller ve initialValue birilikte kullanılmıyor build de tanımla
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adınız',
                    labelStyle: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 10.0,
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  initialValue: _userViewModel.userModel.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 10.0,
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              SizedBox(
                height: 50,
                width: 280,
                child: RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(
                          MaterialCommunityIcons.content_save_outline,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20.0),
                        Text(
                          "Değişiklikleri Kaydet",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 15.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    onPressed: (){
                      _userNameGuncelle(context);
                      _updateProfilePhoto(context);
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _userNameGuncelle(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if(_userViewModel.userModel.userName != _controllerUserName.text){
     var updateResult = await _userViewModel.updateUserName(_userViewModel.userModel.userId, _controllerUserName.text);

     if(updateResult == true){
       PlatformDuyarliAlertDialog(
         title: 'Başarılı',
         content: 'Kullanıcı adını değiştirildi',
         mainButtonText: 'Tamam',
       ).goster(context);
     }else{
       _controllerUserName.text = _userViewModel.userModel.userName;
       PlatformDuyarliAlertDialog(
         title: 'Hata',
         content: 'Bu kullanıcı adı zaten var. Farklı bir kullanıcı adı deneyin',
         mainButtonText: 'Tamam',
       ).goster(context);
     }
    }
  }

  void _updateProfilePhoto(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if(_profilePhoto != null){
      var url = await _userViewModel.uploadFile(_userViewModel.userModel.userId, 'profile_photo', _profilePhoto);
      print("gelen profil url: " + url);

      if(url != null) {
         PlatformDuyarliAlertDialog(
          title: 'Başarılı',
          content: 'Profil değiştirildi',
          mainButtonText: 'Tamam',
        ).goster(context);
      }
    }else{
      print("asdas");
    }
  }

  Future _useCameraForProfile() async{
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    setState(() {
      if (pickedFile != null) {
        _profilePhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _useImageForProfile() async{

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    setState(() {
      if (pickedFile != null) {
        _profilePhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _profilIcinAlanSecmek() {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SizedBox(
            height: 150.0,
            child: Container(
              color: Colors.purple.shade100,
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(
                      Feather.camera,
                      color: Colors.deepPurple,
                      size: 30.0,
                    ),
                    title: Text(
                        "Kamera",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    onTap: (){
                      _useCameraForProfile();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Feather.image,
                      color: Colors.deepPurple,
                      size: 30.0,
                    ),
                    title: Text(
                      "Galeri",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    onTap: (){
                      _useImageForProfile();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


}
