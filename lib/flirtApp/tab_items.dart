import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

enum TabItem {Messages, Users, Profile,}

class TabItemData{
  final String title;
  final IconData iconData;

  TabItemData(this.title, this.iconData);

  static Map<TabItem, TabItemData> tumTablar = {

    TabItem.Messages : TabItemData("Mesajlar ", Feather.message_circle),
    TabItem.Users : TabItemData("Arkadaşlar ", Feather.users),
    TabItem.Profile : TabItemData("Profil ", Feather.user),

  };
}