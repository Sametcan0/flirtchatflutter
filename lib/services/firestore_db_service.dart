import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flirt/model/chat_model.dart';
import 'package:flutter_flirt/model/user_model.dart';
import 'package:flutter_flirt/services/database_base.dart';


class FirestoreDBService implements DBBase{

  final FirebaseFirestore _firebaseDB= FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel userModel) async{

    await _firebaseDB.collection("users").doc(userModel.userId).set(userModel.toMap());

    DocumentSnapshot _okunanUser = await _firebaseDB.doc("users/${userModel.userId}").get();

    Map _okunanUserBilgileriMap = _okunanUser.data();
    UserModel _okunanUserBilgileriNesne = UserModel.fromMap(_okunanUserBilgileriMap);
    print("okunan user nesnesi: "+ _okunanUserBilgileriNesne.toString());
    return true;
  }

  @override
  Future<UserModel> readUser(String userId) async {
    DocumentSnapshot _okunanUser = await _firebaseDB.collection('users').doc(
        userId).get();

    Map<String, dynamic> _okunanUserBilgileri = _okunanUser.data();
    UserModel _okunanUserNesnesi = UserModel.fromMap(_okunanUserBilgileri);
    /*print('Okunan User Nesnesi' + _okunanUserNesnesi.toString());*/
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userId, String newUserName) async{
    var users = await _firebaseDB.collection('users').where('userName', isEqualTo: newUserName).get();
    if(users.docs.length >=1){
      return false;
    }else{
      await _firebaseDB.collection('users').doc(userId).update({'userName': newUserName});
      return true;
    }
  }

  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl) async{
      await _firebaseDB.collection('users').doc(userId).update({'profileUrl': profilePhotoUrl});
      return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async{
    QuerySnapshot querySnapshot = await _firebaseDB.collection('users').get();

    List<UserModel> tumKullanicilar = [];

    for(DocumentSnapshot tekUser in querySnapshot.docs){
      UserModel _tekUser = UserModel.fromMap(tekUser.data());
      tumKullanicilar.add(_tekUser);
    }
    //Map metodu ile
    //tumKullanicilar = querySnapshot.docs.map((tekSatir) => UserModel.fromMap(tekSatir.data())).toList();

    return tumKullanicilar;
  }

  Stream<List<ChatModel>> getAllMessages(String currentSenderUserId, String currentReceiverUserId){
    var snapShots =  _firebaseDB.collection('message').doc(currentSenderUserId + "=>" + currentReceiverUserId)
        .collection('privateMessage').orderBy('dateMessage').snapshots();

  }

  @override
  Stream<List<ChatModel>> getMessages(String currentSenderUserId, String currentReceiverUserId) {
    var snapShots = _firebaseDB.collection('message').doc(currentSenderUserId + "=>" + currentReceiverUserId)
        .collection('privateMessage').orderBy('dateMessage').snapshots();
    return snapShots.map((messagesList) => messagesList.docs.map((message) => ChatModel.fromMap(message.data())).toList());
  }

  Future<bool> saveMessage(ChatModel saveMessage) async{

    var _messageId = _firebaseDB.collection('message').doc().id;
    var _senderDocId = saveMessage.sender + "=>" + saveMessage.receiver;
    var _receiverDocId = saveMessage.receiver + "=>" + saveMessage.sender;
    var _saveMessageMapStructure = saveMessage.toMap();

    await _firebaseDB.collection('message').doc(_senderDocId).collection('privateMessage').doc(_messageId)
    .set(_saveMessageMapStructure);

    _saveMessageMapStructure.update('fromMe', (value) => false);

    await _firebaseDB.collection('message').doc(_receiverDocId).collection('privateMessage').doc(_messageId)
        .set(_saveMessageMapStructure);

    return true;

  }

}

