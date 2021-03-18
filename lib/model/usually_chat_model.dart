import 'package:cloud_firestore/cloud_firestore.dart';

class UsuallyChatModel{

  final String messageSender;
  final String messageReceiver;
  final bool chatCheck;
  final Timestamp createDate;
  final Timestamp seenDate;
  final String lastMessage;
  String receiverUserName;
  String receiverProfileUrl;

  UsuallyChatModel({this.messageSender, this.messageReceiver, this.chatCheck, this.createDate, this.seenDate, this.lastMessage});

  Map<String, dynamic> toMap(){
    return{
      'messageSender' : messageSender,
      'messageReceiver' : messageReceiver,
      'chatCheck' : chatCheck,
      'createDate' : createDate ?? FieldValue.serverTimestamp(),
      'seenDate' : seenDate,
      'lastMessage' : lastMessage ?? FieldValue.serverTimestamp(),
    };
  }

  UsuallyChatModel.fromMap(Map<String, dynamic> map) :
        messageSender = map['messageSender'],
        messageReceiver = map['messageReceiver'],
        chatCheck = map['chatCheck'],
        createDate = map['createDate'],
        seenDate = map['seenDate'],
        lastMessage = map['lastMessage'];

  @override
  String toString() {
    return 'UsuallyChatModel{messageSender: $messageSender, messageReceiver: $messageReceiver, chatCheck: $chatCheck, createDate: $createDate, seenDate: $seenDate, lastMessage: $lastMessage}';
  }
}