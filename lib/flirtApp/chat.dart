import 'package:flutter/material.dart';
import 'package:flutter_flirt/model/chat_model.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {

  final UserModel currentSenderUserChat;
  final UserModel currentReceiverUserChat;

 Chat({this.currentSenderUserChat, this.currentReceiverUserChat});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  var _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    UserModel _currentSenderUser = widget.currentSenderUserChat;
    UserModel _currentReceiverUser = widget.currentReceiverUserChat;
    final _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<ChatModel>> (
                  stream: _userViewModel.getMessagees(_currentSenderUser.userId, _currentReceiverUser.userId),
                  builder: (context, streamMessagesList){

                    if(!streamMessagesList.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else{
                      List<ChatModel> allMessages = streamMessagesList.data;
                      return ListView.builder(
                          itemCount: allMessages.length,
                          itemBuilder: (context, index){
                            return Text(allMessages[index].message);
                          }
                      );
                    }
                  },
                ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: _chatController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xff9575cd),
                          filled: true,
                          hintText: 'Bir mesaj yazın',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: FloatingActionButton(
                      elevation: 3.0,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        MaterialIcons.send,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      onPressed: () async{
                        if(_chatController.text.trim().length > 0) {
                          ChatModel _saveMessage = ChatModel(
                            sender: _currentSenderUser.userId,
                            receiver: _currentReceiverUser.userId,
                            fromMe: true,
                            message: _chatController.text,
                          );
                          var result =  await _userViewModel.saveMessage(_saveMessage);
                          if( result == true){
                            _chatController.clear();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
