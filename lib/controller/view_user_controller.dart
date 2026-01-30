import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/model/user_model.dart';

class ViewUserController extends GetxController{
  RxList<ProfileModel> users= <ProfileModel>[].obs;
  final String category;

  ViewUserController({required this.category});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print(category);
    fetchUser();
  }


  Future<void> fetchUser({String name="",String  number="",  String email=""}) async{
    users.clear();
    users.value = await APIHandler().getUsers(category: category,name: name,number: number,email: email);
  }
}