import 'package:chat_app/ui_layer/themes/my_themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/constants/colors.dart';

class LoginFormField extends StatefulWidget {
  LoginFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.validator,
    required this.formKey,
  }) : super(key: key);
  String label;
   GlobalKey<FormState> formKey;
  TextEditingController controller;
  String? Function(String?)? validator;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  void permission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

  }
  @override
  initState()  {
    super.initState();
   permission();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76.h,
      width: 390.w,
      child: TextFormField(
        style:TextStyle(fontSize: 17.r,color:Colors.black),
        validator: widget.validator,
        controller: widget.controller,
        maxLines: 1,
        minLines: 1,
        expands: false,
        cursorColor: Colors.white,
        cursorWidth: 2.w,
        onChanged: (txt){
          widget.formKey.currentState!.validate();
        },
        decoration: InputDecoration(

          label: Text(widget.label),
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(width: 2, color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(width: 2.w, color: Colors.white),
          ),
          errorBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(width: 2.w, color: Colors.red),
          ),
        ),
        onFieldSubmitted: (txt) {},
      ),
    );
  }
}
