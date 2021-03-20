import 'package:cloud_firestore/cloud_firestore.dart';


class ChatModel{

  final String sender;
  final String receiver;
  final bool fromMe;
  final String message;
  final Timestamp dateMessage;

  ChatModel({this.sender, this.receiver, this.fromMe, this.message, this.dateMessage});

  Map<String, dynamic> toMap(){
    return{
      'sender' : sender,
      'receiver' : receiver,
      'fromMe' : fromMe,
      'message' : message,
      'dateMessage' : dateMessage ?? FieldValue.serverTimestamp(),
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map) :
        sender = map['sender'],
        receiver = map['receiver'],
        fromMe = map['fromMe'],
        message = map['message'],
        dateMessage = map['dateMessage'];

  @override
  String toString() {
    return 'ChatModel{sender: $sender, receiver: $receiver, fromMe: $fromMe, message: $message, dateMessage: $dateMessage}';
  }
}