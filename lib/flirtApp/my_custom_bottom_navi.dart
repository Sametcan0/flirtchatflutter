import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flirt/flirtApp/tab_items.dart';


class MyCustomBottomNavigation extends StatelessWidget {

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomBottomNavigation({Key key, @required this.currentTab, @required this.onSelectedTab, @required this.sayfaOlusturucu, @required this.navigatorKeys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.purple,
            onTap: (index) => onSelectedTab(TabItem.values[index]),
          items: [
            _navItemOlustur(TabItem.Messages),
            _navItemOlustur(TabItem.Users),
            _navItemOlustur(TabItem.Profile),
          ]
        ),
        tabBuilder: (context, index){

          final gosterilecekItem = TabItem.values[index];

          return CupertinoTabView(
            navigatorKey: navigatorKeys[gosterilecekItem],
            builder: (context) {
            return sayfaOlusturucu[gosterilecekItem];
           }
          );
        },
    );
  }
  BottomNavigationBarItem _navItemOlustur (TabItem tabItem) {
    
    final olusturulacakTab = TabItemData.tumTablar[tabItem];
    
    return BottomNavigationBarItem(
        icon: Icon(olusturulacakTab.iconData,color: Colors.white,),
        // ignore: deprecated_member_use
        //title: Text(olusturulacakTab.title),

    );
  }
}
