import 'package:chat_app/shared/constants/colors.dart';
import 'package:chat_app/ui_layer/screens/chat_screen.dart';
import 'package:chat_app/ui_layer/screens/login_screen.dart';
import 'package:chat_app/ui_layer/themes/my_themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data_layer/models/userM_model.dart';

class ToUsersScreen extends StatefulWidget {
  @override
  State<ToUsersScreen> createState() => _ToUsersScreenState();
}

class _ToUsersScreenState extends State<ToUsersScreen> {
  List<UserModel>? users;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => LoginScreen()),
            );
          },
        ),
        backgroundColor: appMainColor,
      ),
      body: ListView.separated(
        itemBuilder: (ctx, idx) {
          if (users == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return InkWell(
              onTap: () {
                toUser(idx);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.r),
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Color.fromARGB(255, 138, 56, 176),
                ),
                child: Text(
                  users![idx].name,
                  style: MyThemes.textStyle2.copyWith(fontSize: 30.r),
                ),
              ),
            );
          }
        },
        separatorBuilder: (ctx, idx) => SizedBox(
          height: 0.h,
        ),
        itemCount: users == null ? 1 : users!.length,
      ),
    );
  }

// any method related to data supposed to be writen in the data layer
  Future<List<UserModel>> getUsers() async {
    List<UserModel> users = (await FirebaseFirestore.instance
            .collection('users')
            .where(
              'email',
              isNotEqualTo: FirebaseAuth.instance.currentUser!.email,
            )
            .get())
        .docs
        .map((e) => UserModel.fromJson(e.data()))
        .toList();
    this.users = users;
    setState(() {});
    return users;
  }

  void toUser(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => ChatScreen(
                userId: users![index].userId.toString(),
              )),
    );
  }
}
