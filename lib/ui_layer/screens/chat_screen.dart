import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/data_layer/models/message_model.dart';
import 'package:chat_app/shared/constants/colors.dart';
import 'package:chat_app/ui_layer/themes/my_themes.dart';
import 'package:chat_app/ui_layer/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data_layer/firebase/my_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.userId}) : super(key: key);
  String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  int messageId = 0;

  late FirebaseFirestore firestore;
  late StreamSubscription querySubscription;
  late CollectionReference messagesRefrence;

  List<Message>? dBMessages;
  ScrollController scrollController = ScrollController();
  final _token = FirebaseMessaging.instance.getToken();
  List<Message> allMessages = [];
  List<Message> currentUserMessages = [];
  List<Message> fromUser = [];
  String toUser = '';
  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    messagesRefrence = firestore.collection('messages');
    super.initState();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    fetchMessagesFromFirestore();
    toUserName();
    print('chat-screen build');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55.h,
        backgroundColor: appMainColor,
        title: InkWell(
            onTap: () async {
              print(DateTime.now());
            },
            child: Text(toUser)),
        centerTitle: true,
        actions: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: appMainColorDarker,
            ),
          ),
          IconButton(
            onPressed: () {
              var user = FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed('/');
            },
            icon: const Icon(Icons.output),
          )
        ],
      ),
      body: Container(
        height: 812.h,
        width: 412.w,
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: allMessages.length,
                    itemBuilder: (ctx, idx) {
                      if (allMessages[idx].sender == true) {
                        return Row(
                          children: [
                            Expanded(child: Container()),
                            ChatBubble(
                                recieved:
                                    !allMessages[idx].sender! ? true : false,
                                massege: allMessages[idx].body),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            ChatBubble(
                                recieved:
                                    !allMessages[idx].sender! ? true : false,
                                massege: allMessages[idx].body),
                            Expanded(child: Container()),
                          ],
                        );
                      }
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              constraints: BoxConstraints(minWidth: 70.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(colors: [
                  Colors.purple.withOpacity(0.4),
                  appMainColor,
                ]),
              ),
              height: 75.h,
              width: 390.w,
              child: TextFormField(
                style: TextStyle(fontSize: 17.r, color: Colors.black),
                controller: controller,
                minLines: null,
                maxLines: null,
                expands: true,
                cursorColor: Colors.white,
                cursorWidth: 2.w,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.image_outlined,
                      size: 40.r,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  border: InputBorder.none,
                  fillColor: appMainColor.withOpacity(0),
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.r,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (controller.text.isEmpty) {
                      } else {
                        await addMessageToFireStore();
                        controller.clear();
                      }
                    },
                  ),
                  hintText: 'send massage...',
                  hintStyle: MyThemes.textStyle2,
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMessageToFireStore() async {
    Message message =
        Message(body: controller.text, sendDate: DateTime.now().toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(await MyFireStore.currentUserDocId())
        .collection('toUser')
        .doc(widget.userId)
        .collection('messages')
        .add(
          message.toJson(),
        );
    setState(() {});
  }

  void fetchMessagesFromFirestore() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(await MyFireStore.currentUserDocId())
        .collection('toUser')
        .doc(widget.userId)
        .collection('messages')
        .snapshots()
        .listen((event) {
      currentUserMessages = (event.docs
          .map((e) => Message.fromJson(e.data(), send: true))
          .toList());
      allMessages = currentUserMessages + fromUser;
      allMessages.sort(
        (a, b) => a.sendDate.compareTo(b.sendDate),
      );
      scrollController.animateTo(
          scrollController.position.maxScrollExtent + 1000,
          duration: const Duration(seconds: 1),
          curve: Curves.linear);
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('toUser')
        .doc(await MyFireStore.currentUserDocId())
        .collection('messages')
        .snapshots()
        .listen((event) {
      print('snapshots 2 called');
      fromUser = (event.docs
          .map((e) => Message.fromJson(e.data(), send: false))
          .toList());
      print(allMessages);
      allMessages = currentUserMessages + fromUser;
      allMessages.sort(
        (a, b) => a.sendDate.compareTo(b.sendDate),
      );
      for (var x in allMessages) {
        print('${x.sendDate}==>${x.body}');
      }
      scrollController.animateTo(
          scrollController.position.maxScrollExtent + 1000,
          duration: Duration(seconds: 1),
          curve: Curves.linear);
      setState(() {});
    });
  }

  Future<void> pushNotification(
    String title,
    String body,
    String id,
  ) async {
    String? token = await _token;
    try {
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(<String, dynamic>{
          'data': {
            'via': 'FlutterFire Cloud Messaging!!!',
            'id': messageId.toString(),
            'name': 'saeed',
            'lastName': 'ashraf',
          },
          'notification': {
            'title': title,
            'body': body,
          },
          'to': '/topics/group',
        }),
      )
          .timeout(Duration(seconds: 2), onTimeout: () {
        print('timeout');
        return http.Response(body, 200);
      });
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  void toUserName() async {
    String name = ((await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .get())
            .data() as Map)['email']
        .toString()
        .split('@')[0];
    toUser = name;
    setState(() {});
  }

  String serverToken =
      'AAAACMRhaX8:APA91bGHp5NngBZ_d1fFqLhmotBvzBHNLr4zhZzRbbSDKY9ukO9mSjf29YAEoWPISayURwp6PGKUKIuPE-ncgRUbezegC3u9ofrLrehZL1igWsXdzVfEuEb9pPWnDbBRINhmmkaH6pp5';
}
