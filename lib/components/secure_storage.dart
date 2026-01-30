import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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


}