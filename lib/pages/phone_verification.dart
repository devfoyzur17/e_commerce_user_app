import 'package:e_commerce_user_app/pages/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class PhoneVerification extends StatefulWidget {
  static const routeName = "phone-verification";
  PhoneVerification({Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}
String vid = "";

class _PhoneVerificationState extends State<PhoneVerification> {
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme:  const IconThemeData(


          color: Colors.black

        ),
      ),
      body: Center(
        child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(15),
              shrinkWrap: true,
              children: [


                Image.asset(
                  "assets/images/phone.jpg",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 40,),
                const Text(
                  "Enter your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      fontStyle: FontStyle.normal),
                ),
                SizedBox(height: 10,),
                Text("We will send you the 6 digit verification code",textAlign: TextAlign.center,),
                SizedBox(height: 40,),


                // todo This is phone textField section
                TextFormField(
                  controller: phoneController,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe6e6e6),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.phone,
                      ),
                      hintText: "Enter your phone number",
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
                SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 15),
                  child: ElevatedButton(
                      onPressed: (){
                        _veryfay();
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                      child: Text(
                        "SEND",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
                SizedBox(height: 100,),
              ],
            )),
      ),
    );
  }

  _veryfay() async {

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("complete");
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          codeController.text = "";
          vid = verificationId;
        });

        Navigator.pushNamed(context, OtpPage.routeName);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }
}
