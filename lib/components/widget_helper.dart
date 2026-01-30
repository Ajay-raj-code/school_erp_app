import 'package:flutter/material.dart';
import 'package:school_erp_mobile/components/color.dart';

class CustomTextField extends StatelessWidget{
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) customValidator;
  final bool enabled;
  final void Function(String) onChanged;
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    String? Function(String?)? customValidator,  this.enabled = true,  void Function(String)? onChanged,
  }) : customValidator = customValidator ?? _defaultValidator, onChanged = onChanged ?? _defaultOnChanged;
    static void _defaultOnChanged(String value) {
    // do nothing
    }
  static String? _defaultValidator(String? value) {

    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(label, style: TextStyle(fontSize: 20),),
        TextFormField(
          enabled:  enabled,
          controller: controller,
          validator: customValidator,
          style: TextStyle(fontSize: 20),
          onChanged: onChanged,

          decoration: InputDecoration(

              hintText: hintText,

              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 20
              ),

              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
      ],
    );
  }


}

class CustomPasswordTextField extends StatelessWidget{
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) customValidator;
  const CustomPasswordTextField({super.key, required this.label, required this.hintText, required this.controller, String? Function(String?)? customValidator,
  }): customValidator = customValidator ?? _defaultValidator;
  static String? _defaultValidator(String? value) {

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(label, style: TextStyle(fontSize: 20),),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 20),
          obscureText: true,
          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 20
            ),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
      ],
    );
  }


}


class CustomButton extends StatelessWidget{

  final String buttonText;
  final VoidCallback onTap;
  final double width;
  const CustomButton({super.key, required this.buttonText, required this.onTap, this.width = double.infinity });

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: onTap,
     child: Container(
       height: 50,
       width: width,
       alignment: Alignment.center,
       decoration: BoxDecoration(
         color:MyColor.blue,
         borderRadius: BorderRadius.circular(10),

       ),
       child: Text(buttonText, style: TextStyle(color: MyColor.white, fontSize: 20),),

     ),
   );
  }

}

class CustomDropDownButton extends StatefulWidget {
  const CustomDropDownButton({super.key});

  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String? selectedRole;

  final List<String> roles = [
    'Manager',
    'Admin Department',
    'Teacher',
    'Driver',
    'Parent/Student',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text("Select Category", style: TextStyle(fontSize: 20),),
        DropdownButtonFormField<String>(
          value: selectedRole,
          hint: Text('Select Role'),
          decoration: InputDecoration(


            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
          items: roles.map((role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedRole = value;
            });
          },
        ),
      ],
    );
  }
}

class CustomIconLableButton extends StatelessWidget {
  final String lable;
  final VoidCallback onTap;
  final IconData icon;

  const CustomIconLableButton({super.key, required this.lable, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
   return  InkWell(
     onTap: onTap,

     child: Container(
       padding: EdgeInsets.all(10),
       child: Row(
         spacing: 10,
         children: [
           Icon(
             icon,
             color: MyColor.blue,
             size: 40,
           ),
           Text(lable, style: TextStyle(fontSize: 25)),
         ],
       ),
     ),
   );
  }
}

class CustomIconButton extends StatelessWidget {

  final VoidCallback onTap;
  final IconData icon;
  final double width;

  const CustomIconButton({super.key, required this.onTap, required this.icon, this.width= 100});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: MyColor.blue,
            borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        width: width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child:  Icon(
          icon,
          color: MyColor.white,
          size: 30,
        ),
      ),
    );
  }
}