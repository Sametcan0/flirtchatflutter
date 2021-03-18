import 'package:flutter/material.dart';
import 'package:flutter_flirt/flirtApp/chat.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  Widget build(BuildContext context) {

    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _userViewModel.getAllUsers();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Arkadaşar"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<UserModel>>(
          future: _userViewModel.getAllUsers(),
          builder: (context, sonuc){

            if(sonuc.hasData == true){
              var tumKullanicilar = sonuc.data;
              if(tumKullanicilar.length > 0){
                return RefreshIndicator(
                    onRefresh: _refreshFriendList,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: tumKullanicilar.length,
                        itemBuilder: (context, index){
                          var currentUserFriend = tumKullanicilar[index];
                          if(currentUserFriend.userId != _userViewModel.userModel.userId){
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(builder: (context) => Chat(
                                    currentSenderUserChat: _userViewModel.userModel,
                                    currentReceiverUserChat: currentUserFriend,
                                  ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(currentUserFriend.userName),
                                subtitle: Text(currentUserFriend.email),
                                leading:  CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage(currentUserFriend.profileUrl),
                                ),
                              ),
                            );
                          }else{
                            return Container();
                          }
                        }
                    ),
                );
              }else{
                return Center(
                  child: Text("Kayıtlı kullanıcı yok"),
                );
              }
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        ),
      ),
    );
  }

  Future<Null> _refreshFriendList() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
    return null;
  }
}
