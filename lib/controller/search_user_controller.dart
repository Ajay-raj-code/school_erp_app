import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/model/user_model.dart';

class SearchUserController extends GetxController{
  RxList<UserModel> users = <UserModel>[].obs;

  Future<void> searchUsers({required String query}) async {
    users.clear();
    users.addAll(await APIHandler().SearchUser(searchQuery: query));
  }
}