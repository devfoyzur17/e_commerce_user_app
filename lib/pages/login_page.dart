// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "login-page";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String _errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                children: [

                  const Text(
                    "Welcome User!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        fontStyle: FontStyle.normal),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/login.jpg",
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // todo This is email textField section
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffe6e6e6),
                        contentPadding: const EdgeInsets.only(left: 10),
                        focusColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
                        hintText: "Enter your email",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15,),

                  // todo this is password textField section
                  TextFormField(
                    obscureText: _isObscure,
                    controller: passwordController,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xffe6e6e6),
                        contentPadding: EdgeInsets.only(left: 10),
                        focusColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field must not be empty';
                      } else {
                        return null;
                      }
                    },
                  ),

                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "forget password?",
                          ))),
                 Text(
                   _errorMessage,
                   style: TextStyle(color: Colors.red),
                 ),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: ElevatedButton(
                        onPressed: _chechValidet,
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        child: Text(
                          "LogIn",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'You have no account? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                          text: ' Sign UP',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),

                          recognizer: TapGestureRecognizer()
                            ..onTap = () {

                            //  Navigator.pushNamed(context, SignUpPage.routeName);

                            }),
                    ]),
                  ),
                  SizedBox(height: 15,),
                  Text("Or signing with", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,letterSpacing: 1,wordSpacing: 1),),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){},
                          child: Image.asset("assets/images/google.png",height: 30,width: 30,fit: BoxFit.cover,)),
                      SizedBox(width: 15,),
                      InkWell(
                        onTap: (){},
                          child: Image.asset("assets/images/facebook.png",height: 30,width: 30,fit: BoxFit.cover,))
                    ],
                  )




                ],
              )),
        ),
      ),
    );
  }

  void _chechValidet() async {
    if (formKey.currentState!.validate()) {
      try {

       final status =   await AuthService.login(emailController.text, passwordController.text);
       if(status){
         if(mounted){
           Navigator.pushReplacementNamed(context, LauncherPage.routeName);
         }
       }
       else{
         AuthService.logout();
         _errorMessage = "You are not admin";
       }



      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message!;
        });
      }
    }
  }
}