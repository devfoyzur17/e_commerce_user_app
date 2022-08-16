import 'package:e_commerce_user_app/pages/login_page.dart';
import 'package:e_commerce_user_app/pages/phone_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  static const routeName ="otp-page";
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

  TextEditingController codeController = TextEditingController();

class _OtpPageState extends State<OtpPage> {
  @override
  void dispose() {

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
      body: ListView(
        children: [
          Image.asset(
            "assets/images/veryfi.jpg",
            height: 300,
            width: double.infinity,
            fit: BoxFit.fitHeight,
          ),
          const Text(
            "Verification number",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 2,
                fontStyle: FontStyle.normal),
          ),
          SizedBox(height: 10,),
          Text("Enter your 6 digit otp code numbers",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
          SizedBox(height: 40,),





          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PinCodeTextField(


              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 45,
                inactiveFillColor: Colors.white,
                activeFillColor: Colors.white,
                inactiveColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).primaryColor,
                selectedFillColor: Theme.of(context).primaryColor.withOpacity(0.1)
              ),
              animationDuration: Duration(milliseconds: 300),

              enableActiveFill: true,

              controller: codeController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                setState(() {
                 // currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                 return true;
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 80, vertical: 15),
            child: ElevatedButton(
                onPressed: (){
                  final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vid, smsCode: codeController.text);
                  FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
                    if(userCredential.user != null){
                      Navigator.pushReplacementNamed(context, LoginPage.routeName);
                    }

                  });
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                child: Text(
                  "VERIFY",
                  style: TextStyle(fontSize: 16),
                )),
          ),


        ],
      ),
    );
  }

}
