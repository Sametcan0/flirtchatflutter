import 'package:flutter_flirt/model/chat_model.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/model/usually_chat_model.dart';

abstract class DBBase{

  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userId);
  Future<bool> updateUserName(String userId, String newUserName);
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl);
  Future<List<UserModel>> getAllUsers();
  Future<List<UsuallyChatModel>> getAllUsuallyChat(String userId);
  Stream<List<ChatModel>> getMessages(String currentSenderUserId, String currentReceiverUserId);
  Future<bool> saveMessage(ChatModel saveMessage);
}