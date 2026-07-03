import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user_model.dart';

class SecureStorage{
  final storage = FlutterSecureStorage();
  Future<void> saveTokens({required String accessToken, required String refreshToken }) async{
    await storage.write(key: "access", value: accessToken);
    await storage.write(key: "refresh", value: refreshToken);
  }

  Future<String?> getAccessToken()async{
    return await storage.read(key: "access");
  }

  Future<String?> getRefreshToken()async{
    return await storage.read(key: "refresh");
  }

  Future<void> clearToken() async{
    await storage.delete(key: "access");
    await storage.delete(key: "refresh");
  }
  Future<void> saveUser({required UserModel user}) async{
    await storage.write(key: "user", value: jsonEncode(user.toJson()));
  }
  Future<UserModel> getUser() async{
    return UserModel.fromJson(jsonDecode(await storage.read(key: "user") ?? ""));
  }


}