import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/components/color.dart';
import 'package:school_erp_mobile/components/widget_helper.dart';

class StudentRegistrationFormPage extends StatefulWidget{
  @override
  State<StudentRegistrationFormPage> createState() => _StudentRegistrationFormPageState();
}

class _StudentRegistrationFormPageState extends State<StudentRegistrationFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _standardController = Get.put(StandardController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back() , icon: const Icon(Icons.arrow_back, color: MyColor.white,)),
        title: const Text(
          "Create Student",
          style: TextStyle(color: MyColor.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: MyColor.blue,
      ),
      body:
      SingleChildScrollView(
        child:Form(child:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              CustomTextField(
                label: "First Name",
                hintText: "first name",
                controller: _firstNameController,
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
                hintText: "Last name",
                controller: _lastNameController,
                customValidator: (value) {

                  return null;
                },
              ),
              CustomTextField(
                label: "Father Name",
                hintText: "Father name",
                controller: _fatherNameController,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Father Name cannot be empty!";
                  } else if (value.length < 2) {
                    return "Father Name cannot be less then 2 characters";
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: "Mother Name",
                hintText: "Mother name",
                controller: _motherNameController,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mother Name cannot be empty!";
                  } else if (value.length < 2) {
                    return "Mother Name cannot be less then 2 characters";
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: "Mother Name",
                hintText: "Mother name",
                controller: _motherNameController,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mother Name cannot be empty!";
                  } else if (value.length < 2) {
                    return "Mother Name cannot be less then 2 characters";
                  }
                  return null;
                },
              ),
              Obx(() => DropdownButtonFormField(items: _standardController.standards.map((element) =>DropdownMenuItem(child: element["name"]) ,).toList(), onChanged: (value) {

              },),)

            ],
          ),
        )),
      ),
    );
  }
}

class StandardController extends GetxController{
  RxList standards= [].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onIntialization();
  }

  Future<void> onIntialization() async {
    standards.value = await APIHandler().GetStandards();

  }
}