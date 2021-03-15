import 'package:flutter_flirt/repository/user_repository.dart';
import 'package:flutter_flirt/services/fake_auth_service.dart';
import 'package:flutter_flirt/services/firebase_auth_service.dart';
import 'package:flutter_flirt/services/firebase_storage_service.dart';
import 'package:flutter_flirt/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocactor(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}