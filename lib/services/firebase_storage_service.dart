import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_flirt/services/storage_base.dart';

class FirebaseStorageService implements StorageBase{

    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    StorageReference _storageReference;



  @override
  Future<String> uploadFile(String userId, String fileType, File uploadFile) async{

    _storageReference = _firebaseStorage.ref().child(userId).child(fileType).child('profile_photo.png');
    var uploadTask = _storageReference.putFile(uploadFile);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url;
  }

}