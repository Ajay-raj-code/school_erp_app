import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/components/secure_storage.dart';
import 'package:school_erp_mobile/model/user_model.dart';

class LoginController extends GetxController {
  RxList addUser= [].obs;
  RxList viewUser= [].obs;
  RxList permission = [].obs;
  UserModel? currentUser ;
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initionlization();

  }
  Future<void> initionlization() async {
    currentUser = await APIHandler().getMyProfile();
    permission.value = await APIHandler().GetMyPermission();
    print("called permission");
    if (permission.contains("create_director")) {
      addUser.add("director");
    }
    if (permission.contains("create_manager")) {
      addUser.add("manager");
    }
    if (permission.contains("create_admin_dipartment")) {
      addUser.add("admin dipartment");
    }
    if (permission.contains("create_teacher")) {
      addUser.add("teacher");
    }
    if (permission.contains("create_driver")) {
      addUser.add("driver");
    }
    if (permission.contains("create_parent")) {
      addUser.add("parent");
    }

    if(permission.contains("view_director")){
      viewUser.add("director");
    }
    if(permission.contains("view_manager")){
      viewUser.add("manager");
    }
    if(permission.contains("view_admin_dipartment")){
      viewUser.add("admin_dipartment");
    }
    if(permission.contains("view_teacher")){
      viewUser.add("teacher");
    }
    if(permission.contains("view_driver")){
      viewUser.add("driver");
    }
    if(permission.contains("view_parent")){
      viewUser.add("parent");
    }
    print("length of fun ${viewUser.length}");
  }

}