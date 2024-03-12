import 'package:chat_app/shared/methods/methodes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(onReceive);

  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: false,
      builder: (ctx, widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(),
        themeMode: ThemeMode.light,
        onGenerateRoute: MyRouter.onRouteGenerate,
      ),
    );
  }
}

Future<void> onReceive(RemoteMessage handler) async {
  print('back ground notfication revceived ');
}
