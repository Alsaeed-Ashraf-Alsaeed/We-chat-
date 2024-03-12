import 'package:chat_app/ui_layer/themes/my_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/constants/colors.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({Key? key, required this.recieved, required this.massege})
      : super(key: key);
  String massege;
  bool recieved;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 3.w,
        ),
        if (recieved == true)
          CircleAvatar(
            child: Icon(Icons.person),
            backgroundColor: Color.fromARGB(255, 131, 54, 116),
            radius: 35.r,
          ),
        Container(
          padding: EdgeInsets.all(10.r),
          margin: EdgeInsets.symmetric(vertical: 7, horizontal: 6),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: recieved == true ? appMainColorLighter : appMainColorDarker,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.r),
                bottomRight: recieved ? Radius.circular(15.r) : Radius.zero,
                topLeft: Radius.circular(18.r),
                bottomLeft: recieved ? Radius.zero : Radius.circular(18.r)),
          ),
          constraints: BoxConstraints(minHeight: 50.h, maxWidth: 300.w),
          child: Text(
            massege,
            style: MyThemes.textStyle2,
          ),
        ),
      ],
    );
  }
}
