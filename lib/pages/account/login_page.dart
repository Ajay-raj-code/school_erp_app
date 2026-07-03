import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/components/color.dart';
import 'package:school_erp_mobile/components/widget_helper.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _schoolCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    bool itIsWindow= false;
    if(Platform.isWindows){
      itIsWindow = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(builder: (context, constraints) => Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2F5BFF),
              Color(0xFF1E3CFF),
              Color(0xFF3A0CA3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
              width: width,
              child:               Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,width: double.infinity,),
                  Container(
                    height: 140,
                    width: 140,
                    padding: EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 10),
                    decoration: BoxDecoration(
                      color: MyColor.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset("assets/icons/graduation_hat.png", fit: BoxFit.fill,),
                  ),
                  Text("School Management System", style: TextStyle(color: MyColor.white, fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Poppins', ),),
                  SizedBox(height: 8,),
                  Text("Empowering Education, Simplifying Administration", style: TextStyle(color: Colors.white70, fontSize: 14.5,),),
                  SizedBox(height: 12,),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: itIsWindow?540:width-60 ,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: MyColor.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                          spacing: 20,
                          children: [
                            Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                            CustomTextField(label: "Username", hintText: "Username", controller: _username,),
                            CustomTextField(label: "School Code", hintText: "School Code", controller: _schoolCode,),
                            CustomPasswordTextField(label: "Password", hintText: "Password", controller: _password,),
                            CustomButton(buttonText: "Login", onTap: () async{
                              print("Login");
                              print(_password.text);
                              print("ok");
                              bool result =  await LoginHandler().login(username: _username.text.trim(), password: _password.text.trim(), schoolCode: _schoolCode.text.trim());
                              print(result);
                              if(result == true){
                                Get.offNamed("/");
                              }else {
                                // Get.snackbar("Error", "Invalid credentials! Try again!", duration: Duration(seconds: 5));
                              }

                            },),
                            GestureDetector(
                              onTap: () {

                              },
                              child: Text("Forgot Password?", style: TextStyle(color: MyColor.blue, fontSize: 20),),
                            )

                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              )

          ),
        ),
      ),),
    );
  }

}