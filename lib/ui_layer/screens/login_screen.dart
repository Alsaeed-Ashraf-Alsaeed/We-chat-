import 'package:chat_app/data_layer/firebase/my_firestore.dart';
import 'package:chat_app/data_layer/models/userM_model.dart';
import 'package:chat_app/shared/constants/colors.dart';
import 'package:chat_app/ui_layer/screens/chat_screen.dart';
import 'package:chat_app/ui_layer/screens/to_users_screen.dart';
import 'package:chat_app/ui_layer/themes/my_themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared/methods/methodes.dart';
import '../widgets/login_form_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool wasLogin = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? existingEmailValidator;
  String? weakPasswordValidator;
  String? wrongEmailValidator;
  String? wrongPasswordValidator;
  String? inValidEmailValidator;
  bool wasLoading = false;
  int built = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (currentUser.emailVerified == false) {
        currentUser.delete();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    built++;
    print('loginScreen built $built');
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        width: 412.w,
        height: 892.h,
        decoration: BoxDecoration(color: appMainColorLighter),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Text(
                ' We Chat ',
                textAlign: TextAlign.start,
                style: MyThemes.textStyle1.copyWith(
                  color: appMainColor,
                ),
              ),
              Center(
                child: SizedBox(
                  height: 230.h,
                  child: Image.asset(
                    'assets/images/loginphoto.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 600),
                height: wasLogin ? 380.h : 460.h,
                width: 400.w,
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        firstChild: Text(
                          'Sign in',
                          style: GoogleFonts.artifika(
                            color: Colors.white,
                            fontSize: 30.spMin,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        secondChild: Text(
                          'Sign Up',
                          style: GoogleFonts.artifika(
                            color: Colors.white,
                            fontSize: 35.spMin,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        crossFadeState: wasLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 600),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      LoginFormField(
                        formKey: formKey,
                        validator: (txt) {
                          if (!wasLogin) {
                            if (emailController.text.isEmpty) {
                              return 'empty field';
                            } else if (existingEmailValidator != null) {
                              return 'email already taken';
                            } else if (inValidEmailValidator != null) {
                              return inValidEmailValidator;
                            }
                          } else {
                            if (wrongEmailValidator != null) {
                              return 'wrong EmailAdress';
                            } else if (inValidEmailValidator != null) {
                              return 'Invalid EmailAddress';
                            }
                          }
                        },
                        label: 'Email',
                        controller: emailController,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      LoginFormField(
                        formKey: formKey,
                        validator: (txt) {
                          if (!wasLogin) {
                            if (passwordController.text.isEmpty) {
                              return 'empty field';
                            } else if (weakPasswordValidator != null) {
                              return 'weak password !!';
                            } else {
                              return null;
                            }
                          } else {
                            return wrongPasswordValidator;
                          }
                        },
                        label: 'Password',
                        controller: passwordController,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 600),
                        opacity: wasLogin ? 0 : 1,
                        child: AnimatedContainer(
                          margin: EdgeInsets.only(bottom: 10.h),
                          height: wasLogin ? 0 : 79.h,
                          duration: Duration(milliseconds: 600),
                          child: LoginFormField(
                            formKey: formKey,
                            validator: (txt) {
                              if (!wasLogin) {
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  return 'not identical passwords';
                                }
                              }
                            },
                            label: 'Confirm Password',
                            controller: confirmPasswordController,
                          ),
                        ),
                      ),
                      wasLoading == false
                          ? Column(
                              children: [
                                Center(
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    height: 55.h,
                                    width: 290.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: appMainColor),
                                      onPressed: () async {
                                        if (wasLogin) {
                                          wasLoading = true;
                                          setState(() {});
                                          await login(emailController.text,
                                              passwordController.text);
                                          wasLoading = false;
                                          setState(() {});
                                          formKey.currentState!.validate();
                                        } else {
                                          wasLoading = true;
                                          setState(() {});
                                          await createNewUser(
                                                  emailController.text,
                                                  passwordController.text,
                                                  confirmPasswordController
                                                      .text)
                                              .timeout(
                                                  const Duration(seconds: 4),
                                                  onTimeout: () {
                                            showSnackBar(
                                                'poor internet connection',
                                                context);
                                          });
                                          wasLoading = false;
                                          setState(() {});
                                          formKey.currentState!.validate();
                                        }
                                      },
                                      child: Text(
                                        wasLogin
                                            ? 'Login'
                                            : 'Sign Up (Register)',
                                        style: TextStyle(
                                          fontSize: 25.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      wasLogin
                                          ? 'don\'t have an account?'
                                          : 'already have an account ?',
                                      style: MyThemes.textStyle3,
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: appMainColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            wasLogin =
                                                wasLogin == true ? false : true;
                                          });
                                        },
                                        child: Text(
                                          'Click here',
                                          style: MyThemes.textStyle3.copyWith(
                                              color: appMainColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.r),
                                        ))
                                  ],
                                ),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  'you can register using any of the below',
                  style: MyThemes.textStyle3,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: buildSocialItems('assets/images/facebook.png'),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc('1')
                          .set({'name': 'ali'});
                    },
                    child: buildSocialItems('assets/images/google.png'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/chat_screen');
                    },
                    child: Icon(
                      Icons.phone,
                      size: 45.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createNewUser(
      String email, String password, String confirmPassword) async {
    try {
      if (password == confirmPassword) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await addUserToFirestore();
        weakPasswordValidator = null;
        existingEmailValidator = null;
        inValidEmailValidator = null;
        wrongEmailValidator = null;
        User user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();
        wasLogin = true;
        showSnackBar(
            'email successfully created ,'
            'verification code sent to your email , confirm it and sign in ',
            context);
      } else {
        showSnackBar('please enter two identical passwords ', context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        weakPasswordValidator = 'weak password , please enter a stronger one ';
        print('weak password');
      } else if (e.code == 'email-already-in-use') {
        existingEmailValidator = 'this email is already used';
        print('this account is already exciting ');
      } else {
        inValidEmailValidator = 'invalid Email';
        print('========${e.code}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(
            Duration(seconds: 3),
          );
      wrongEmailValidator = null;
      wrongPasswordValidator = null;
      inValidEmailValidator = null;
      User user = FirebaseAuth.instance.currentUser!;
      if (user.emailVerified == true) {
        updateUserToken();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => ToUsersScreen()));
      } else {
        showSnackBar('please verify your email first', context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        wrongPasswordValidator = 'Wrong password';
        inValidEmailValidator = null;
        wrongEmailValidator = null;
      } else if (e.code == 'user-not-found') {
        wrongEmailValidator =
            'Wrong Email, enter an existing one or create an account ';
        inValidEmailValidator = null;
        wrongPasswordValidator = null;
      } else {
        print('=======${e.code}');
      }

      //
    } catch (e) {
      print(e.toString());
    }
  }

  buildSocialItems(String photo) {
    return Container(
      height: 45.h,
      width: 45.w,
      decoration: BoxDecoration(
        color: appMainColorLighter,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(photo), fit: BoxFit.cover),
      ),
    );
  }

  Future<void> addUserToFirestore() async {
    print('add user called');
    FirebaseFirestore.instance.runTransaction((transaction) async {
      List<QueryDocumentSnapshot> usersQuery = (await FirebaseFirestore.instance
              .collection('users')
              .orderBy('userId')
              .get())
          .docs;
      int lastUserId = usersQuery.isEmpty
          ? 0
          : ((await transaction.get(usersQuery.last.reference)).data()
              as Map)['userId'];
      UserModel userModel = UserModel(
          name: emailController.text.split('@')[0],
          userId: lastUserId + 1,
          email: emailController.text,
          password: passwordController.text,
          tokens: [await FirebaseMessaging.instance.getToken()]);
      print(userModel);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.userId.toString())
          .set(
            userModel.toJson(),
          );
    });
  }

  Future<void> updateUserToken() async {
    List<QueryDocumentSnapshot> usersQuery = (await FirebaseFirestore.instance
            .collection('users')
            .where(
              'email',
              isEqualTo: FirebaseAuth.instance.currentUser!.email,
            )
            .get())
        .docs;

    String currentUserRefId =
        usersQuery.isEmpty ? '0' : usersQuery[0].reference.id;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserRefId)
        .update({
      'tokens': <String>[(await MyFireStore.getToken())!]
    });
  }
}
