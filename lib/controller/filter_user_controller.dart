import 'package:get/get.dart';

class FilterUserController extends GetxController{
  RxBool filterVeiw = false.obs;
  List<String> filterCategory=["Name","Number","Email"];
  RxString seletedFilterCategory = "Name".obs;
}