import 'package:flutter/material.dart';
import 'package:flutter_flirt/flirtApp/home_page.dart';
import 'package:flutter_flirt/flirtApp/signIn/sign_in_page.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';



class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _userViewModel = Provider.of<UserViewModel>(context);

    if(_userViewModel.state == ViewState.Idle){
      if(_userViewModel.userModel == null){
        return SignInPage();
      }else{
        return HomePage(user: _userViewModel.userModel);
      }
    }else{
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}



