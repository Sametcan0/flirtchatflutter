import 'dart:io';

abstract class StorageBase{

  Future<String> uploadFile(String userId, String fileType, File uploadFile);
}