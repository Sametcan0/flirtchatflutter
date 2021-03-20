import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flirt/commonWidget/platform_duyarli_alert_dialog.dart';
import 'package:flutter_flirt/flirtApp/profiler_edit_page.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage>{



  @override
  Widget build(BuildContext context) {

    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    print("Profil sayfasındaki user değerleri: " + _userViewModel.userModel.toString());

    return
    Scaffold(
      //backgroundColor: Colors.grey.shade300,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.purple.shade100,
        ),
        child: Drawer(
          child: FlatButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Row(
              children: [
                Icon(
                  Ionicons.md_exit,
                  size: 30.0,
                  color: Colors.white,
                ),
                SizedBox(width: 20.0,),
                Text(
                  "Çıkış Yap",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
                Feather.edit_3,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditPage()));
            },
          ),
        ],
        title: Row(
          children: [
            SizedBox(width: 100.0),
            Text("Profil"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 70.0,
                backgroundImage: NetworkImage(_userViewModel.userModel.profileUrl),
              ),
              SizedBox(height: 50.0),
              Text(
                _userViewModel.userModel.userName,
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: Colors.deepPurple,
                    letterSpacing: .5,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                _userViewModel.userModel.email,
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: Colors.deepPurple.shade300,
                    letterSpacing: .5,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool sonuc = await _userViewModel.signOut();
    print(_userViewModel.userModel == null);
    return sonuc;
  }

  // ignore: missing_return
  Future<bool> _cikisIcinOnayIste(BuildContext context) async{
    final sonuc = await PlatformDuyarliAlertDialog(
        title: 'Çıkış',
        content: 'Çıkış yapmak istediğinizden emin misiniz ?',
        mainButtonText:'Evet',
        cancelButtonText: 'Hayır',
    ).goster(context);
    if(sonuc == true){
      _cikisYap(context);
    }
  }
}

