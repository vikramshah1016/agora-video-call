import 'dart:convert';

import 'package:agora_video_call/login/phone.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_client.dart';

class MyVerify extends StatefulWidget {
  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  void initState() {
    super.initState();
    //listenOtp();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode().toString();
    // submitOtp();
  }

  void submitOtp() async {
    try {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Loading......'),
        backgroundColor: Colors.green,
      ));

      var response = await ApiClient().verifyOtp({'otp':smsCode,'mobile':MyPhone.mobileNumber});

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if(!response.error){

        prefs.clear();
        prefs.setBool('isLogin',true);
        prefs.setString('user', jsonEncode(response.user));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ));

        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);

      }else{
        Navigator.pushNamedAndRemoveUntil(context, "verify", (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ));
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wrong otp..!'),
        backgroundColor: Colors.green,
      ));
    }
  }

  var smsCode = "";

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
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
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              PinFieldAutoFill(
                currentCode: smsCode,
                codeLength: 6,
                onCodeChanged: (code) {
                  setState(() {
                    smsCode = code.toString();
                  });
                },
              ),
              const SizedBox(
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
                    onPressed: () {
                      submitOtp();
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,"phone",(route) => false);
                      },
                      child: const Text(
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
