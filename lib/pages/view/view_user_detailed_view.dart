import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/model/user_model.dart';
import 'package:school_erp_mobile/pages/view/view_user.dart';

import '../../components/color.dart';

class ViewUserDetailedView extends StatelessWidget{
  final ProfileModel user = Get.arguments["user"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightBackBlue,
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back() , icon: Icon(Icons.arrow_back, color: MyColor.white,)),
        title: Text(
          "${capitalizeFirstLetter(user.user.firstName)} ${capitalizeFirstLetter(user.user.lastName)}",
          style: TextStyle(color: MyColor.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: MyColor.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            customLayoutContainer(child: Row(
              spacing: 10,
              children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text(capitalizeFirstLetter(user.user.firstName)[0], style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w800),),
              ),
              RichText(text: TextSpan(
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
                text: "${capitalizeFirstLetter(user.user.firstName)} ${capitalizeFirstLetter(user.user.lastName)}\n" ,
                children: [
                  TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.normal),
                    text: "${capitalizeFirstLetter(user.user.category)} • IBM School"
                  )
                ]
              )),
            ],)),
            customLayoutContainer(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                    SizedBox(width: 135, child: Text("Phone:"),),
                    Text(user.phoneNumber),
                  ],
                ),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                    SizedBox(width: 135, child: Text("Secondary Phone:"),),
                    Text(user.secondaryPhoneNumber?? ""),
                  ],
                ),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                    SizedBox(width: 135, child: Text("Email:"),),
                    Text(user.user.email.toLowerCase()),
                  ],
                ),
              ],
            )),
            customLayoutContainer(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Address Information",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                      SizedBox(width: 135, child: Text("Current Address:"),),
                    Text(user.currentAddress),
                  ],
                ),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                    SizedBox(width: 135, child: Text("Permanent Address:"),),
                    Text(user.permanentAddress),
                  ],
                ),
              ],
            )),
            customLayoutContainer(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("System Info",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                    SizedBox(width: 135, child: Text("Created By:"),),
                    Expanded(child: Text(user.createdBy??"")),
                    
                  ],
                ),
                Divider(thickness: 1.5,),
                Row(
                  children: [
                    SizedBox(width: 135, child: Text("Created At:"),),
                    Expanded(child: Text(user.createdAt.toString(), maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true,)),

                  ],
                ),
              ],
            ))

          ],
        ),
      ),
    );
  }
  
  Widget customLayoutContainer({ required Widget child,}){
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(8.0),
      width: double.infinity,
      child: child,
    ),);
  }

}