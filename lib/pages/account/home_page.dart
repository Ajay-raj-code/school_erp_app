import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/components/color.dart';
import 'package:school_erp_mobile/components/constants.dart';
import 'package:school_erp_mobile/components/secure_storage.dart';
import 'package:school_erp_mobile/components/widget_helper.dart';
import 'package:school_erp_mobile/controller/home_page_controller.dart';
import 'package:school_erp_mobile/pages/account/login_controller.dart';
import 'package:school_erp_mobile/routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginController _loginController  = Get.put(LoginController());
  final home_page_controller = Get.put(HomePageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    bool isWindow = Platform.isWindows;
    return Scaffold(
      backgroundColor: MyColor.white,
      drawer: !isWindow?     drawer(): null,
      appBar: !isWindow? AppBar(backgroundColor: MyColor.blue): null,
      body: Row(
        children: [
          isWindow?drawer():SizedBox(),
        ],
      ),
    );
  }
  Widget drawer(){
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Platform.isWindows?0:20),
          bottomRight: Radius.circular(Platform.isWindows?0:20),
        ),
      ),
      child: Column(
        children: [
          // this button shows general details of user
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
            color: Color(0xff1C2849),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MyColor.white,

                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "http://10.0.2.2:8000${_loginController.currentUser?.profilePicture}" ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print("it is called ");
                        print(_loginController.currentUser?.profilePicture);
                        return Image.asset("assets/icons/person.png");
                      },
                    ),
                  ),

                ),
                SizedBox(height: 10),
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: MyColor.white,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "Mr. Adhitya",
                  style: TextStyle(
                    color: MyColor.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // this button shows create user
          Obx(
                () => _loginController.addUser.isNotEmpty?Column(
              children: [
                CustomIconLableButton(lable:"Add User", onTap: () {
                  home_page_controller.createUserStatus.value =
                  !home_page_controller.createUserStatus.value;
                }, icon: Icons.person_add_alt_1),

                AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  child: home_page_controller.createUserStatus.value == true
                      ? Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                        children: _loginController.addUser.map((element) => InkWell(

                          onTap: () {
                            if(element == UserCategoryExtension(UserCategory.parent).value){
                              Get.toNamed(Routes.registrationForm,arguments: {"category": UserCategory.parent});

                            }
                            else if (element == UserCategoryExtension(UserCategory.teacher).value){
                              Get.toNamed(Routes.registrationForm, arguments: {"category": UserCategory.teacher} );
                            }
                            else if (element == UserCategoryExtension(UserCategory.driver).value){
                              Get.toNamed(Routes.registrationForm, arguments: {"category": UserCategory.driver} );
                            }
                            else if (element == UserCategoryExtension(UserCategory.manager).value){
                              Get.toNamed(Routes.registrationForm, arguments: {"category": UserCategory.manager} );
                            }
                            else if (element == UserCategoryExtension(UserCategory.adminDepartment).value){
                              Get.toNamed(Routes.registrationForm, arguments: {"category": UserCategory.adminDepartment} );
                            }
                            else if (element == UserCategoryExtension(UserCategory.director).value){
                              Get.toNamed(Routes.registrationForm, arguments: {"category": UserCategory.director} );
                            }





                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Create $element",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20,),
                                    softWrap: true,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),).toList()


                    ),
                  )
                      : SizedBox(),
                ),
              ],
            ): SizedBox(),
          ),

          Obx(() => _loginController.viewUser.isNotEmpty?Column(
            children: [
              CustomIconLableButton(lable:"View User", onTap: () {
                home_page_controller.viewUserStatus.value =
                !home_page_controller.viewUserStatus.value;
              }, icon: Icons.person_add_alt_1),

              AnimatedSize(duration: Duration(milliseconds: 500),
                child: home_page_controller.viewUserStatus.value == true?
                Padding(padding: const EdgeInsets.only(left: 50), child: Column(
                  children: _loginController.viewUser.map((element) => InkWell(
                    onTap: () {
                      Get.toNamed(Routes.viewUserPage, arguments: {"category": element});
                    },

                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Text(
                              "View $element",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 20,),
                              softWrap: true,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),).toList(),
                ),):
                SizedBox(),

              )
            ],

          ):SizedBox(),),
          CustomIconLableButton(lable: "Message", onTap: () {
            Get.toNamed(Routes.chatView);
          }, icon: Icons.message_outlined),

          CustomIconLableButton(lable: "Track Location", onTap: () {
            SecureStorage().clearToken();
            Get.toNamed(Routes.trackLocationView);
          }, icon: Icons.location_history),
          // this button for logout
          CustomIconLableButton(lable: "Logout", onTap: () {
            SecureStorage().clearToken();
            Get.offAllNamed(Routes.login);
          }, icon: Icons.logout),

        ],
      ),
    );
  }
}
