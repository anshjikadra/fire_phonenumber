import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class home_page extends StatefulWidget {
  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  TextEditingController t1 = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String vid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone OTP")),
      body: Column(
        children: [
          TextField(
            controller: t1,
          ),
          ElevatedButton(
              onPressed: () async {
                print(t1.text);

                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+91${t1.text}',
                  //========================
                  verificationCompleted:
                      (PhoneAuthCredential credential) async {
                    await auth.signInWithCredential(credential);
                  },
                  //=============================

                  verificationFailed: (FirebaseAuthException e) async {
                    if (e.code == 'invalid-phone-number') {
                      print('The provided phone number is not valid.');
                    }
                  },
                  //=================================
                  codeSent: (String verificationId, int? resendToken) {
                    vid = verificationId;
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Text("Send Otp")),
          OtpTextField(
            numberOfFields: 6,
            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) async {
              print(verificationCode);
              String smsCode = verificationCode;

              // Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: vid, smsCode: smsCode);

              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential);
            }, // end onSubmit
          ),
          ElevatedButton(onPressed: () {

          }, child:Text("Submit")),
        ],
      ),
    );
  }
}
