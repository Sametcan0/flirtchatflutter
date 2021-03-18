import 'package:flutter/material.dart';
import 'package:flutter_flirt/flirtApp/chat.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/model/usually_chat_model.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mesajlar"),
          ],
        ),
      ),
      body: FutureBuilder<List<UsuallyChatModel>>(
        future:
            _userViewModel.getAllUsuallyChat(_userViewModel.userModel.userId),
        builder: (context, chatList) {
          if (!chatList.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var allUsuallyChat = chatList.data;

            return RefreshIndicator(
              onRefresh: _refreshChatList,
              child: ListView.builder(
                  itemCount: allUsuallyChat.length,
                  itemBuilder: (context, index) {
                    var currentUsuallyChat = allUsuallyChat[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => Chat(
                                      currentSenderUserChat:
                                          _userViewModel.userModel,
                                      currentReceiverUserChat: UserModel.id(
                                          userId: currentUsuallyChat
                                              .messageReceiver,
                                          profileUrl: currentUsuallyChat
                                              .receiverProfileUrl),
                                    )));
                      },
                      child: ListTile(
                        title: Text(currentUsuallyChat.receiverUserName),
                        subtitle: Text(currentUsuallyChat.lastMessage),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              currentUsuallyChat.receiverProfileUrl),
                        ),
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }

  Future<Null> _refreshChatList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
    return null;
  }
}
