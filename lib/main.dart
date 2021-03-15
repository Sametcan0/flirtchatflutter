import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flirt/flirtApp/landing_page.dart';
import 'package:flutter_flirt/locator.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocactor();
  runApp(
    MultiProvider(
      child: MyApp(),
        providers: [
          ChangeNotifierProvider(create: (context)=> UserViewModel()),
        ]
    ),
  );
}

//ignore: must_be_immutable
class MyApp extends StatelessWidget {

  Future<FirebaseApp> _init  = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _init,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Flirt',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                ),
                home: LandingPage(),
            );
        }else if(snapshot.hasError){
          print(snapshot.error);
          return Container();
        }
        else {
          return Loading();
        }
      },
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }
}
