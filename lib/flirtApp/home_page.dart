import 'package:flutter/material.dart';
import 'package:flutter_flirt/flirtApp/friends_page.dart';
import 'package:flutter_flirt/flirtApp/messages_page.dart';
import 'package:flutter_flirt/flirtApp/my_custom_bottom_navi.dart';
import 'package:flutter_flirt/flirtApp/profil_page.dart';
import 'package:flutter_flirt/flirtApp/tab_items.dart';
import 'package:flutter_flirt/model/user_model.dart';

class HomePage extends StatefulWidget {

  final UserModel user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TabItem _currentTab = TabItem.Messages;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Messages : GlobalKey<NavigatorState>(),
    TabItem.Users : GlobalKey<NavigatorState>(),
    TabItem.Profile : GlobalKey<NavigatorState>(),
  };

  //TabItem _onSelectedTab = TabItem.Profile;

  Map<TabItem, Widget> tumSayfalar(){
    return {
      TabItem.Users : KullanicilarPage(),
      TabItem.Profile : ProfilPage(),
      TabItem.Messages: MessagesPage(),
    };
  }

  UserModel user;

  @override
  void initState() {

    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(sayfaOlusturucu: tumSayfalar(), currentTab: _currentTab, navigatorKeys: navigatorKeys,onSelectedTab: (secilenTab){

        if(secilenTab == _currentTab){
          navigatorKeys[secilenTab].currentState.popUntil((route) => route.isFirst);
        }

        setState(() {
          _currentTab = secilenTab;
        });

        print("Seçilen tab item: "+ secilenTab.toString());
      },
      ),
    );
  }
}




