import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/components/color.dart';
import 'package:school_erp_mobile/components/constants.dart';
import 'package:school_erp_mobile/components/widget_helper.dart';
import 'package:school_erp_mobile/controller/registration_from_page_controller.dart';
import 'package:school_erp_mobile/routes/routes.dart';
import 'package:share_plus/share_plus.dart';

class RegistrationFormPage extends StatefulWidget {

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final UserCategory category = Get.arguments["category"];
  final _formkey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController fNameController = TextEditingController();

  final TextEditingController lNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController pController = TextEditingController();

  final TextEditingController sController = TextEditingController();

  final TextEditingController pAddressController = TextEditingController();

  final TextEditingController cAddressController = TextEditingController();

  // parents
  final TextEditingController suppotiveName = TextEditingController();

  final TextEditingController occupation = TextEditingController();

  // Teacher
  final TextEditingController  subjectSpecialization = TextEditingController();

  final TextEditingController  qaulification = TextEditingController();

  //Driver
  final TextEditingController licenseNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usernameStatusController = Get.put(RegistrationUsernameController());
    final registrationAddressController = Get.put(
      RegistrationAddressController(),
    );
    final width = Get.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back() , icon: Icon(Icons.arrow_back, color: MyColor.white,)),
        title: Text(
          "Create ${category.label}",
          style: TextStyle(color: MyColor.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: MyColor.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0,bottom: 25.0,right: 10.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: width - 70,
                      child: CustomTextField(
                        label: "Username",
                        hintText: "username",
                        controller: usernameController,
                        customValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username is required";
                          }

                          final regex = RegExp(r'^[a-zA-Z0-9@]+$');

                          if (!regex.hasMatch(value)) {
                            return "Only letters, numbers, and @ are allowed";
                          }

                          if (value.length < 8) {
                            return "Username must be at least 8 characters";
                          }

                          return null;
                        },
                        onChanged: (value) async {
                          if(value != null && value.isNotEmpty && value.length>=8){
                            usernameStatusController.checkUserName(userName: value);

                          }
                          else{
                            usernameStatusController.status.value = false;
                          }

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 10),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(40),
                        child: Obx(
                          () => Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: usernameStatusController.status.value
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            child: Icon(
                              usernameStatusController.status.value
                                  ? Icons.check
                                  : Icons.clear,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomPasswordTextField(
                  label: "Password",
                  hintText: "password",
                  controller: passwordController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    }

                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }

                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must contain at least one uppercase letter";
                    }

                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return "Password must contain at least one lowercase letter";
                    }

                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "Password must contain at least one number";
                    }

                    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                      return "Password must contain at least one special character (!@#\$&*~)";
                    }

                    return null;
                  },
                ),
                CustomPasswordTextField(
                  label: "Confirm Password",
                  hintText: " Confirm password",
                  controller: confirmPasswordController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm password cannot be empty!";
                    } else if (passwordController.text != value) {
                      return "Password and confirm password must be same!";
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: "First Name",
                  hintText: "first name",
                  controller: fNameController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty!";
                    } else if (value.length < 2) {
                      return "Name cannot be less then 2 characters";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Last Name",
                  hintText: "last name",
                  controller: lNameController,
                ),
                CustomTextField(
                  label: "Email",
                  hintText: "Email",
                  controller: emailController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email required";
                    }

                    final regex = RegExp(
                      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@'
                      r'[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                    );

                    if (!regex.hasMatch(value)) {
                      return "Invalid email format";
                    }

                    return null;
                  },
                ),

                if(category == UserCategory.parent)
                  parentForm(),
                if(category == UserCategory.teacher)
                  teacherForm(),
                if(category == UserCategory.driver)
                  driverForm(),


                CustomTextField(
                  label: "Phone Number",
                  hintText: "Phone number",
                  controller: pController,
                  customValidator: (value) {
                    final regex = RegExp(r'^[6-9]\d{9}$');
                    if (value == null || value.isEmpty) {
                      return "Phone number cannot be empty";
                    } else if (!regex.hasMatch(value)) {
                      return "Enter a valid 10-digit mobile number";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Secondary number",
                  hintText: "Secondary number",
                  controller: sController,
                  customValidator: (value) {

                    return null;
                  },
                ),
                CustomTextField(
                  label: "Current address",
                  hintText: "Current address",
                  controller: cAddressController,
                  onChanged: (value) {
                    if (registrationAddressController.checked.value) {
                      pAddressController.text = value;
                    }
                  },
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Permanent address cannot be empty";
                    } else if (value.length < 5) {
                      return "Enter at lest 5 characters";
                    }
                    return null;
                  },
                ),
                Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        registrationAddressController.checked.value =
                            !registrationAddressController.checked.value;
                        if (registrationAddressController.checked.value) {
                          pAddressController.text = cAddressController.text;
                        } else {
                          pAddressController.clear();
                        }
                      },
                      child: Obx(
                        () => AnimatedContainer(
                          duration: Duration(milliseconds: 200),

                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: registrationAddressController.checked.value
                                ? MyColor.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400),
                          ),

                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            child: registrationAddressController.checked.value
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: MyColor.white,
                                  )
                                : SizedBox(),
                          ),
                        ),
                      ),
                    ),

                    Text("Same as Current Address"),
                  ],
                ),
                Obx(
                  () => CustomTextField(
                    label: "Permanent address",
                    hintText: "Permanent address",
                    controller: pAddressController,
                    enabled: !registrationAddressController.checked.value,
                  ),
                ),
                CustomButton(buttonText: "Submit", onTap: () async {

                  print("tysgar");
                  if(_formkey.currentState!.validate()){
                    print("cheked");
                    if(usernameStatusController.status.value){

                      if(category == UserCategory.parent){
                        bool result = await APIHandler().createUser(userName: usernameController.text.trim(), occupation: occupation.text.trim(), suppotiveName: suppotiveName.text.trim(), password: passwordController.text.trim(), firstName: fNameController.text.trim(), lastName: lNameController.text.trim(), email: emailController.text.trim(), category: UserCategory.parent.value, phoneNumber: pController.text.trim(), secondaryPhoneNumber: sController.text.trim(), currentAddress: cAddressController.text.trim(), permanentAddress: pAddressController.text.trim());
                        if(result== true){
                          bottomSheet(username: usernameController.text.trim(), password: passwordController.text.trim(), schoolId: "15", width: width,onTapNewForm: () {
                            clearController();
                            Get.back();


                          },);

                          print("User created");
                        }
                        else {
                          print("not success");
                        }



                        print(UserCategory.parent.value);
                      }
                      else if (category == UserCategory.teacher){
                        bool result =  await APIHandler().createUser(subjectSpecialization: subjectSpecialization.text.trim(),qualification: qaulification.text.trim(),userName: usernameController.text.trim(), password: passwordController.text.trim(), firstName: fNameController.text.trim(), lastName: lNameController.text.trim(), email: emailController.text.trim(), category: UserCategory.teacher.value, phoneNumber: pController.text.trim(), secondaryPhoneNumber: sController.text.trim(), currentAddress: cAddressController.text.trim(), permanentAddress: pAddressController.text.trim() );
                        if(result== true){
                          bottomSheet(username: usernameController.text.trim(), password: passwordController.text.trim(), schoolId: "15", width: width,onTapNewForm: () {
                            clearController();
                            Get.back();


                          },);

                          print("User created");
                        }
                        else {
                          print("not success");
                        }
                      }
                      else if (category == UserCategory.driver){
                        bool result =  await APIHandler().createUser(userName: usernameController.text.trim(), licenseNumber: licenseNumber.text.trim(), password: passwordController.text.trim(), firstName: fNameController.text.trim(), lastName: lNameController.text.trim(), email: emailController.text.trim(), category: UserCategory.driver.value, phoneNumber: pController.text.trim(), secondaryPhoneNumber: sController.text.trim(), currentAddress: cAddressController.text.trim(), permanentAddress: pAddressController.text.trim());
                        if(result== true){
                          bottomSheet(username: usernameController.text.trim(), password: passwordController.text.trim(), schoolId: "15", width: width,onTapNewForm: () {
                            clearController();
                            Get.back();


                          },);

                          print("User created");
                        }
                        else {
                          print("not success");
                        }
                      }
                      else if (category == UserCategory.manager){
                        bool result =  await APIHandler().createUser(userName: usernameController.text.trim(), password: passwordController.text.trim(), firstName: fNameController.text.trim(), lastName: lNameController.text.trim(), email: emailController.text.trim(), category: UserCategory.manager.value, phoneNumber: pController.text.trim(), secondaryPhoneNumber: sController.text.trim(), currentAddress: cAddressController.text.trim(), permanentAddress: pAddressController.text.trim());
                        if(result== true){
                          bottomSheet(username: usernameController.text.trim(), password: passwordController.text.trim(), schoolId: "15", width: width,onTapNewForm: () {
                            clearController();
                            Get.back();


                          },);

                          print("User created");
                        }
                        else {
                          print("not success");
                        }
                      }
                      else if (category == UserCategory.adminDepartment){
                        bool result =  await APIHandler().createUser(userName: usernameController.text.trim(), password: passwordController.text.trim(), firstName: fNameController.text.trim(), lastName: lNameController.text.trim(), email: emailController.text.trim(), category: UserCategory.adminDepartment.value, phoneNumber: pController.text.trim(), secondaryPhoneNumber: sController.text.trim(), currentAddress: cAddressController.text.trim(), permanentAddress: pAddressController.text.trim());
                        if(result== true){
                          bottomSheet(username: usernameController.text.trim(), password: passwordController.text.trim(), schoolId: "15", width: width,onTapNewForm: () {
                            clearController();
                            Get.back();


                          },);

                          print("User created");
                        }
                        else {
                          print("not success");
                        }
                      }
                      else if (category == UserCategory.director){
                        //Not implementing yet
                      }

                    }
                    else{
                      Get.snackbar("Error", "Username not available",snackPosition: SnackPosition.TOP,duration: Duration(seconds: 5),backgroundColor: Colors.red,colorText: Colors.white);
                    }
                  }





                },),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
  void clearController(){
   usernameController.clear() ;

    passwordController.clear() ;

     confirmPasswordController.clear() ;

      fNameController.clear()  ;

      lNameController.clear() ;

      emailController.clear() ;

      pController.clear() ;

      sController.clear() ;

      pAddressController.clear() ;
      cAddressController.clear();

    // parents
      suppotiveName.clear();

      occupation.clear() ;

    // Teacher
       subjectSpecialization.clear() ;

      qaulification.clear() ;

    //Driver
      licenseNumber.clear() ;
  }

  Widget parentForm (){
    return Column(
      spacing: 15,
      children: [
        CustomTextField(
          label: "Supportive Name",
          hintText: "Husband/wife Name",
          controller: suppotiveName,
          customValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Name cannot be empty!";
            } else if (value.length < 2) {
              return "Name cannot be less then 2 characters";
            }
            return null;
          },
        ),
        CustomTextField(
          label: "Occupation",
          hintText: "Occupation",
          controller: occupation,
          customValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Occupation cannot be empty!";
            } else if (value.length <= 5) {
              return "Occupation cannot be less then 5 characters";
            }
            return null;
          },
        ),

      ],
    );
  }

  Widget teacherForm() {
    return Column(
      spacing: 15,
      children: [
        CustomTextField(
          label: "Subject Specialization",
          hintText: "Subject Specialization",
          controller: subjectSpecialization,
          customValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Subject cannot be empty!";
            } else if (value.length < 2) {
              return "Subject cannot be less then 2 characters";
            }
            return null;
          },
        ),
        CustomTextField(
          label: "Qualification",
          hintText: "Qualification ",
          controller: qaulification,
          customValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Qualification cannot be empty!";
            } else if (value.length < 2) {
              return "Qualification cannot be less then 2 characters";
            }
            return null;
          },
        ),
      ],
    );


  }

  Widget driverForm(){
    return CustomTextField(
      label: "license number",
      hintText: "license number",
      controller: licenseNumber,
      customValidator: (value) {
        if (value == null || value.isEmpty) {
          return "license cannot be empty!";
        } else if (value.length <= 16) {
          return "license cannot be less then 16 characters";
        }
        return null;
      },
    );
  }
}

void sharebleText({required String username, required String password, required String schoolId}){
  SharePlus.instance.share(
    ShareParams(text: "Username : $username\nSchool id : $schoolId\nPassword: $password", title: "Welcome user!"),
  );
}
void bottomSheet({required String username, required String password, required String schoolId, required double width,required VoidCallback onTapNewForm}){

  Get.bottomSheet(
      isDismissible: false,
      Container(
    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
    ),
    height: 270,
    width: double.infinity,

    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.center,
                height : 30,
                width: 30,
                decoration : BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.check,color: Colors.white,size: 22,)),
            Text("User Created Successfully",style: TextStyle(color: MyColor.blue, fontSize: 25 ,fontWeight: FontWeight.w800),),

          ],
        ),
        RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black),
                children: [
                  TextSpan(text: "Username: $username\n"),
                  TextSpan(text: "SchoolId: $schoolId\n"),
                  TextSpan(text: "Password: $password"),
                ]
            )),
        const SizedBox(height: 10,),

        Row(
          spacing: 10,

          children: [
            CustomIconButton(
                width: (width-40)/3,
                onTap: () {
                  sharebleText(username: username, password: password, schoolId: schoolId);

                }, icon: Icons.share),
            CustomButton(
              width: (width-40)/3,
              buttonText: "New Form", onTap:onTapNewForm,),
            CustomButton(
              width:(width-40)/3,
              buttonText: "Close", onTap:() {
                Get.offAllNamed(Routes.home);


            },),

          ],
        )


      ],
    ),
  ));
}