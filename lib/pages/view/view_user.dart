import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/components/color.dart';
import 'package:school_erp_mobile/controller/filter_user_controller.dart';
import 'package:school_erp_mobile/controller/view_user_controller.dart';
import 'package:school_erp_mobile/model/user_model.dart';
import 'package:school_erp_mobile/routes/routes.dart';

class ViewUserPage extends StatelessWidget{
  final String category = Get.arguments["category"];
  final TextEditingController _textFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(ViewUserController(category: category), permanent: false);
    final _filterController = Get.put(FilterUserController(), permanent: false);

    return Scaffold(
      backgroundColor: MyColor.lightBackBlue,
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back() , icon: Icon(Icons.arrow_back, color: MyColor.white,)),
        title: Text(
          "View ${category.toUpperCase()}",
          style: TextStyle(color: MyColor.white, fontWeight: FontWeight.w800),
        ),
        actions: [

          IconButton(onPressed: () {
            _filterController.filterVeiw.value=!_filterController.filterVeiw.value;

          }, icon: Icon(Icons.search_outlined, color: Colors.white, size: 35,)),
          SizedBox(width: 20,),
        ],
        backgroundColor: MyColor.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          children: [
            Obx(() => _filterController.filterVeiw.value?Row(
              spacing: 10,
              children: [
                SizedBox(
                  width: 130,
                  child: DropdownButtonFormField(
                    dropdownColor: MyColor.blue,
                    iconEnabledColor: MyColor.white,
                    decoration: InputDecoration(
                    filled: true,
                      fillColor: MyColor.blue,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      )

                    ),
                  value: _filterController.seletedFilterCategory.value,
                    items:_filterController.filterCategory.map((element) {
                    return DropdownMenuItem<String>(value: element,child: Text(element.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 18),
                    ));
                  },).toList(), onChanged: (value) {
                    _filterController.seletedFilterCategory.value =  value.toString();

                  },),
                ),
                Expanded(
                  child: Obx(() => TextFormField(
                    controller: _textFilterController,
                    decoration: InputDecoration(
                      hintText:"Enter ${_filterController.seletedFilterCategory.value}",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColor.blue,
                            width: 1.5,
                          )
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColor.blue,
                            width: 1.5,
                          )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.blue,
                              width: 1.5
                          )
                      ),
                    ),
                    onChanged: (value) {
                      if(_filterController.seletedFilterCategory.value.toLowerCase()=="name"){
                        _controller.fetchUser(name: value);
                      }
                      else  if(_filterController.seletedFilterCategory.value.toLowerCase()=="number"){
                        _controller.fetchUser(number: value);
                      }
                      else  if(_filterController.seletedFilterCategory.value.toLowerCase()=="email"){
                        _controller.fetchUser(email: value);
                      }
                    },
                  ),),
                )

              ],
            ):SizedBox(),),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: _controller.users.length,

                itemBuilder: (context, index) {
                  ProfileModel model = _controller.users[index];
                  return InkWell(
                    onTap:  () {
                      Get.toNamed(Routes.viewUserDeatiledPage, arguments: {"user": model});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        borderRadius:BorderRadius.circular(10) ,
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                alignment: Alignment.center,
                                child: Text(_controller.users[index].user.firstName[1].toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 35),),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text("${capitalizeFirstLetter(model.user.firstName)} ${capitalizeFirstLetter(model.user.lastName)}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                                  Text("${capitalizeFirstLetter(model.user.category)} • IBM School", style: TextStyle(fontSize: 18, color: Colors.grey),),

                                  Text(model.phoneNumber, style: TextStyle(fontSize: 18),),
                              ],),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Icon(Icons.navigate_next_outlined, color: Colors.grey, size: 30,),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },),),
            )
          ],
        ),
      ),
    );
  }
}
String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}