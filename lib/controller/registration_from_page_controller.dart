import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';

class RegistrationUsernameController extends GetxController{

  RxBool status = false.obs;

  Future<void> checkUserName({required String userName} ) async{
    status.value = await APIHandler().checkUserName(username: userName);
  }
}
class RegistrationAddressController extends GetxController{
  RxBool checked = false.obs;
}