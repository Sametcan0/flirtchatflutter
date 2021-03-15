import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_flirt/commonWidget/platform_duyarli_widget.dart';




class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget{

  final String title;
  final String content;
  final String mainButtonText;
  final String cancelButtonText;

  PlatformDuyarliAlertDialog({ @required this.title, @required this.content, @required this.mainButtonText, this.cancelButtonText});

  Future<bool> goster(BuildContext context) async{
    return Platform.isIOS ? await showCupertinoDialog<bool>(context: context, builder: (context) => this) :
    await showDialog<bool>(context: context, builder: (context) => this, barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButonlariniAyarla(context)
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _dialogButonlariniAyarla(context)
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];

    if(Platform.isIOS){

      if(cancelButtonText != null){
        tumButonlar.add(
          CupertinoDialogAction(
              child: Text(cancelButtonText),
            onPressed: (){
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      tumButonlar.add(
        CupertinoDialogAction(
          child: Text(mainButtonText),
          onPressed: (){
            Navigator.of(context).pop(true);
          } ,
        ),
      );
    }else{

      if(cancelButtonText != null){
        tumButonlar.add(
          FlatButton(
            child: Text(cancelButtonText),
            onPressed: (){
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      tumButonlar.add(
          FlatButton(
            child: new Text("Tamam"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
      );
    }
    return tumButonlar;
  }
}