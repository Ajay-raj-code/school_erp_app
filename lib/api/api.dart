import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/components/secure_storage.dart';
import 'package:school_erp_mobile/model/user_model.dart';
import 'package:school_erp_mobile/routes/routes.dart';

class LoginHandler {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.155.24.112:8000",
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      },
    ),
  );

  Future<bool> login({
    required String username,
    required String password,
    required String schoolCode,
  }) async {
    try {
      print("api $password");
      final response = await dio.post(
        '/api/account/login/',
        data: {
          "username": username,
          "password": password,
          "school_id": schoolCode,
        },
      );
      print(response.data);
      Map<String, dynamic> user = response.data;
      SecureStorage().saveTokens(
        accessToken: user["access"],
        refreshToken: user["refresh"],
      );
      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }
}

class APIHandler {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.155.24.112:8000/",
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(AuthInterceptor());

  Future<bool> createUser({
    required String userName,
    required String password,
    String suppotiveName = "",
    String occupation = "",
    String subjectSpecialization = "",
    String qualification = "",
    String vehicleNumber = "",
    String licenseNumber = "",
    required String phoneNumber,
    required String secondaryPhoneNumber,
    required String currentAddress,
    required String permanentAddress,
    required String firstName,
    required String lastName,
    required String email,
    required String category,
  }) async {
    try {
      Map<String, dynamic> data = {
        "user": {
          "username": userName,
          "password": password,
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "category": "e74c1faeaaf44772b227f8a9dbac6a93",
        },

        "phone_number": phoneNumber,
        "secondary_phone_number": secondaryPhoneNumber,
        "current_address": currentAddress,
        "permanent_address": permanentAddress,
      };
      if (suppotiveName.isNotEmpty) {
        data["suppotive_name"] = suppotiveName;
      }
      if (occupation.isNotEmpty) {
        data["occupation"] = occupation;
      }
      if (subjectSpecialization.isNotEmpty) {
        data["subject_specialization"] = subjectSpecialization;
      }
      if (qualification.isNotEmpty) {
        data["qaulification"] = qualification;
      }
      if (licenseNumber.isNotEmpty) {
        data["license_number"] = licenseNumber;
      }
      if (vehicleNumber.isNotEmpty) {
        data["vehicle_number"] = vehicleNumber;
      }

      final response = await dio.post("api/account/user-profile/", data: data);
      print(response);
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("user");
      print(e);
      return false;
    }
  }

  Future<List<ProfileModel>> getUsers({required String category,String name="",String  number="",  String email=""}) async{
    try {
      final response = await dio.get(
        "api/account/user-profile/",
        queryParameters: {"category_name": category,"name":name,"number":number, "email":email},
      );

      print(response);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data["results"];

        List<ProfileModel> profiles = jsonList
            .map((json) => ProfileModel.fromJson(json))
            .toList();
        return profiles;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<bool> checkUserName({required String username}) async {
    try {
      final response = await dio.get(
        "api/account/check-username/",
        queryParameters: {"username": username},
      );
      print(response);
      if (response.statusCode == 200) {
        if (response.data["data"]["available"]) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<String>> GetMyPermission() async {
    try {
      print("clling permission");
      final response = await dio.get("api/account/check-my-permission/");
      print(response);
      List<String> data = List<String>.from(
        await response.data["data"]["permissions"],
      );
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<dynamic>> GetStandards() async {
    try {
      print("clling permission");
      final response = await dio.get("api/academics/standards/");
      print(response);
      List<dynamic> data = List<String>.from(await response.data["data"]);
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

final Dio dio = Dio();
final Dio refreshDio = Dio(); // NO interceptors

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage().getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await SecureStorage().getRefreshToken();

        if (refreshToken == null) {
          await _logout();
          return handler.reject(err);
        }

        final response = await refreshDio.post(
          'http://10.155.24.112:8000/api/account/token/refresh/',
          data: {'refresh': refreshToken},
        );
        print(response);
        print("line 12");
        final newAccess = response.data['access'];
        final newRefresh = response.data['refresh'];

        await SecureStorage().saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );

        // retry original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';

        final retryResponse = await dio.fetch(err.requestOptions);

        return handler.resolve(retryResponse);
      } catch (e) {
        // 🔥 refresh token failed
        await _logout();
        return handler.reject(err);
      }
    }

    handler.next(err);
  }

  /// 🔐 logout + redirect
  Future<void> _logout() async {
    await SecureStorage().clearToken();

    // ensure navigation works from interceptor
    if (Get.currentRoute != Routes.login) {
      Get.offAllNamed(Routes.login);
    }
  }
}
