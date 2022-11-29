import 'dart:convert';

import 'package:agora_video_call/home.dart';
import 'package:agora_video_call/servicies/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:agora_video_call/DatabaseManager/DatabaseManager.dart';
// import 'package:agora_video_call/phone.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userData.dart';


class MyVerify extends StatefulWidget {
  final loginService loginservice ;
   MyVerify({required this.loginservice});

  @override
  State<MyVerify> createState() => _MyVerifyState();


}

class _MyVerifyState extends State<MyVerify> {


  void initState() {
    super.initState();
    listenOtp();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode().toString();
    // submitOtp();
    print("OTP listen Called");
  }

  // void submitOtp() async{
  //   try{
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: MyPhone.verificationId, smsCode: smsCode);
  //     await auth.signInWithCredential(credential);
  //     var id = FirebaseAuth.instance.currentUser?.uid;
  //     await DatabaseManager().createCallerInfo(MyPhone.mobileNumber,id!);
  //     Navigator.pushNamedAndRemoveUntil(context,"home",(route) => false);
  //   }catch(e){
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Wrong otp..!'),
  //       backgroundColor: Colors.green,
  //     ));
  //   }
  // }

  // final FirebaseAuth auth = FirebaseAuth.instance;
  var smsCode = "";
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    Future<void> _VerifyNumber() async{
      String _smsCode = smsCode;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('counter', "yes");
      dynamic response = await widget.loginservice.phoneVerify(_smsCode);
      if(response.statusCode == 200){
        var userdata = UserData.fromJson(jsonDecode(response.body));
        print(userdata);


        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Verify successfully'),
                backgroundColor: Colors.green,
              ));
        String token = userdata.user.app_token;
        Navigator.pushNamed(context, '/home', arguments: token);

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => Home(userdata:userdata ),
        //   ),
        // );

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('error'),
          backgroundColor: Colors.red,
        ));
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img1.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              PinFieldAutoFill(
                currentCode: smsCode,
                codeLength: 6,
                onCodeChanged: (code){
                  setState(() {
                    smsCode = code.toString();
                  });
                  if(code.toString().length == 6){
                    // submitOtp();
                  }
                },
              ),
              // Pinput(
              //   length: 6,
              //   // defaultPinTheme: defaultPinTheme,
              //   // focusedPinTheme: focusedPinTheme,
              //   // submittedPinTheme: submittedPinTheme,
              //
              //   showCursor: true,
              //   onCompleted: (pin) => smsCode = pin,
              // ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: (){
                      _VerifyNumber();
                      // submitOtp
                    },
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        _VerifyNumber();
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
