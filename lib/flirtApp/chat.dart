import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flirt/model/chat_model.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/viewmodels/user_view_model.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {

  final String receiverUserId;
  final UserModel senderUser;

  const Chat({Key key, this.receiverUserId, this.senderUser}) : super(key: key);


  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  var _chatController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    String receiverUserId = widget.receiverUserId;

    final _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<UserModel>(
          future: getReceiverUser(receiverUserId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel receiverUser = snapshot.data;
              return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                    NetworkImage(receiverUser.profileUrl),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      receiverUser.userName,
                      style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                      color: Colors.white,
                      ),
                    ),
                   ),
                  ],
              );
            }else{
            return Center(
            child: CircularProgressIndicator(),
            );
            }
          },
        ),
      ),
      body: FutureBuilder<UserModel>(
        future: getReceiverUser(receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel receiverUser = snapshot.data;
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<ChatModel>>(
                      stream: _userViewModel.getMessagees(
                          _userViewModel.userModel.userId, receiverUser.userId),
                      builder: (context, streamMessagesList) {
                        if (!streamMessagesList.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<ChatModel> allMessages = streamMessagesList.data;
                          return ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              itemCount: allMessages.length,
                              itemBuilder: (context, index) {
                                return _creatChatBubble(allMessages[index]);
                              });
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
                            onPressed: () async {
                              if (_chatController.text
                                  .trim()
                                  .length > 0) {
                                ChatModel _saveMessage = ChatModel(
                                  sender: _userViewModel.userModel.userId,
                                  receiver: receiverUser.userId,
                                  fromMe: true,
                                  message: _chatController.text,
                                );
                                var result =
                                await _userViewModel.saveMessage(_saveMessage);
                                if (result == true) {
                                  _chatController.clear();
                                  _scrollController.animateTo(
                                      0.0,
                                      duration: const Duration(
                                          milliseconds: 100),
                                      curve: Curves.easeOut);
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
            );
          } else {
            print("Chat hata");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<UserModel> getReceiverUser(String receiverUserId) async {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    UserModel receiverUser = await _userViewModel.readUser(receiverUserId);
    return receiverUser;
  }

  Widget _creatChatBubble(ChatModel currentMessage) {

    Color _inCommingMessageColor = Colors.deepPurple.shade500;
    Color _sentMessageColor = Colors.deepPurple.shade300;

    var _hoursAndMinValue = '';

    try {
      _hoursAndMinValue =
          _hoursAndMinShow(currentMessage.dateMessage ?? Timestamp(1, 1));
    } catch (e) {
      print("hata mesaj saati: " + e.toString());
    }

    var messageFromMe = currentMessage.fromMe;

    if (messageFromMe == true) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: _sentMessageColor,
                    ),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(4.0),
                    child: Text(
                      currentMessage.message,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(_hoursAndMinValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /*CircleAvatar(
                  backgroundImage:
                  NetworkImage(),
                ),*/
                SizedBox(width: 5.0),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: _inCommingMessageColor,
                    ),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(4.0),
                    child: Text(
                      currentMessage.message,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(_hoursAndMinValue),
              ],
            ),
          ],
        ),
      );
    }
  }


  String _hoursAndMinShow(Timestamp dateMessage) {
    var _formatter = DateFormat.Hm();
    var _formattedDate = _formatter.format(dateMessage.toDate());
    return _formattedDate;
  }
}
