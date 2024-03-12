import 'package:chat_app/ui_layer/screens/chat_screen.dart';
import 'package:chat_app/ui_layer/screens/to_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../ui_layer/screens/login_screen.dart';
import '../../ui_layer/themes/my_themes.dart';
import '../constants/colors.dart';

class MyRouter {
 static  Route onRouteGenerate(RouteSettings settings){
   User? user = FirebaseAuth.instance.currentUser;
     switch(settings.name){
       case '/':
          return MaterialPageRoute(builder: (ctx)=>user ==null? LoginScreen():ToUsersScreen());
       default : return MaterialPageRoute(builder: (ctx)=>LoginScreen());
      }

   }
}
void showSnackBar(String content,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: MyThemes.textStyle1.copyWith(fontSize: 15),
      ),
      backgroundColor: appMainColor,
    ),
  );
}